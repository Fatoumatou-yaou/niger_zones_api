module Api
    module V1
        class LocalitesController < ApplicationController
          def index
            if params[:region_id] && params[:department_id] && params[:commune_id]
              department = Department.find_by(id: params[:department_id], region_id: params[:region_id])

              if department
                commune = department.communes.find_by(id: params[:commune_id])

                if commune
                  pagy, localites = pagy(commune.localites)
                  render json: {
                    localites: ActiveModelSerializers::SerializableResource.new(localites).as_json,
                    pagination: pagy_metadata(pagy)
                  }
                else
                  render json: { erreur: "Aucune commune trouvée pour ce département." }, status: :not_found
                end
              else
                render json: { erreur: "Aucun département trouvé pour cette région." }, status: :not_found
              end

            elsif params[:commune_id]
              commune = Commune.find_by(id: params[:commune_id])

              if commune
                pagy, localites = pagy(commune.localites)
                render json: {
                  localites: ActiveModelSerializers::SerializableResource.new(localites, include: [ :commune ]).as_json,
                  pagination: pagy_metadata(pagy)
                }
              else
                render json: { erreur: "Commune non trouvée." }, status: :not_found
              end
            else
              pagy, localites = pagy(Localite.all)
              render json: {
                localites: ActiveModelSerializers::SerializableResource.new(localites).as_json,
                pagination: pagy_metadata(pagy)
              }
            end
          end

          def show
            if params[:region_id] && params[:department_id] && params[:commune_id]
              department = Department.find_by(id: params[:department_id], region_id: params[:region_id])

              if department
                commune = department.communes.find_by(id: params[:commune_id])

                if commune
                  localite = commune.localites.find_by(id: params[:id])

                  if localite
                    render json: ActiveModelSerializers::SerializableResource.new(localite, include: [ :commune ]).as_json
                  else
                    render json: { erreur: "Localité non trouvée dans cette commune." }, status: :not_found
                  end
                else
                  render json: { erreur: "Aucune commune trouvée pour ce département." }, status: :not_found
                end
              else
                render json: { erreur: "Aucun département trouvé pour cette région." }, status: :not_found
              end
            else
              render json: { erreur: "Les paramètres region_id, department_id et commune_id sont requis." }, status: :unprocessable_entity
            end
          end

          def search
            localites = Localite.all
            localites = localites.where("name ILIKE ?", "%#{params[:name]}%") if params[:name].present?
            localites = localites.where("population_totale >= ?", params[:population_totale].to_i) if params[:population_totale].present?

            if localites.any?
              render json: ActiveModelSerializers::SerializableResource.new(localites).as_json
            else
              render json: { erreur: "Aucune localité ne répond aux critères." }, status: :not_found
            end
          end

          def by_department
            department = Department.find_by(id: params[:department_id])

            if department
              pagy, localites = pagy(department.localites)

              if localites.any?
                render json: {
                  localites: ActiveModelSerializers::SerializableResource.new(localites, include: [ :department ]).as_json,
                  pagination: pagy_metadata(pagy)
                }
              else
                render json: { message: "Aucune localité trouvée pour ce département." }, status: :not_found
              end
            else
              render json: { erreur: "Département introuvable." }, status: :not_found
            end
          end

          def by_region
            region = Region.find_by(id: params[:region_id])

            if region
              pagy, localites = pagy(region.localites)

              if localites.any?
                render json: {
                  localites: ActiveModelSerializers::SerializableResource.new(localites, include: [ :region ]).as_json,
                  pagination: pagy_metadata(pagy)
                }
              else
                  render json: { message: "Aucune localité trouvée pour cette région." }, status: :not_found
              end
            else
                render json: { erreur: "Région introuvable." }, status: :not_found
            end
            end
        end
    end
end
