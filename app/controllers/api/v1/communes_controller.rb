module Api
    module V1
      class CommunesController < ApplicationController
        def index
          # Si region_id et department_id sont présents
          if params[:region_id] && params[:department_id]
            department = Department.find_by(id: params[:department_id], region_id: params[:region_id])

            if department
              pagy, communes = pagy(department.communes)
              render json: {
                communes: ActiveModelSerializers::SerializableResource.new(communes, include: [ :localites ]).as_json,
                pagination: pagy_metadata(pagy)
              }
            else
              render json: { erreur: "Aucun département trouvé pour cette région." }, status: :not_found
            end

          # Si seul department_id est présent
          elsif params[:department_id]
            pagy, communes = pagy(Commune.where(department_id: params[:department_id]))
            render json: {
              communes: ActiveModelSerializers::SerializableResource.new(communes).as_json,
              pagination: pagy_metadata(pagy)
            }

          # Si aucun paramètre n'est présent, renvoyer toutes les communes
          else
            pagy, communes = pagy(Commune.all)
            render json: {
              communes: ActiveModelSerializers::SerializableResource.new(communes).as_json,
              pagination: pagy_metadata(pagy)
            }
          end
        end

        def show
          if params[:region_id] && params[:department_id]
            department = Department.find_by(id: params[:department_id], region_id: params[:region_id])

            if department
              commune = department.communes.find_by(id: params[:id])
              if commune
                render json: ActiveModelSerializers::SerializableResource.new(commune, include: [ :department, :localites ]).as_json
              else

                render json: { erreur: "Commune non trouvée dans ce département." }, status: :not_found
              end
            else
              render json: { erreur: "Aucun département trouvé pour cette région." }, status: :not_found
            end
          else
            render json: { erreur: "Les paramètres region_id et department_id sont requis." }, status: :unprocessable_entity
          end
        end

        def search
          communes = Commune.all
          communes = Commune.joins(:localites)
                    .select("communes.*, SUM(localites.population_totale) AS population")
                    .group("communes.id")

          if params[:name].present?
            communes = communes.where("communes.name ILIKE ?", "%#{params[:name]}%")
          end

          if params[:population_totale].present?
            communes = communes.having("SUM(localites.population_totale) >= ?", params[:population_totale].to_i)
          end

          if communes.empty?
            render json: { erreur: "Aucune Commune ne correspond aux critères" }, status: :not_found
          else
            # render json: ActiveModelSerializers::SerializableResource.new(communes).as_json
            render json: communes.map { |communes| communes.attributes.merge(population: communes.population.to_i) }
          end
      end

        def statistics
          commune = Commune.find(params[:id])

          if commune.nil?
            render json: { erreur: "Commune introuvable" }, status: :not_found and return
          end

          statistics = {
              population_totale: commune.localites.sum(:population_totale),
              total_hommes: commune.localites.sum(:homme),
              total_femmes: commune.localites.sum(:femme),
              total_menages: commune.localites.sum(:menage),
              total_localites: commune.localites.count
          }

          render json: { commune: commune.name, statistics: statistics }
        end
      end
    end
end
