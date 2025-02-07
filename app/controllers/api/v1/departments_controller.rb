module Api
    module V1
        class DepartmentsController < ApplicationController
            def index
                if params[:region_id]
                  pagy, departments = pagy(Department.where(region_id: params[:region_id]).includes(:communes))
                else
                  pagy, departments = pagy(Department.includes(:communes).all)
                end

                metadata = pagy_metadata(pagy)

                response = {
                  departments: ActiveModelSerializers::SerializableResource.new(departments, include: :communes),
                  meta: metadata
                }

                render json: response.as_json()
            end

            def show
                if params[:region_id] && params[:id]
                    department = Department.find_by(id: params[:id], region_id: params[:region_id])
                    if department
                     render json: ActiveModelSerializers::SerializableResource.new(department, include: [ :region, :communes, :localites ]).as_json
                    else
                     render json: { erreur: "Ce département n'existe pas." }, status: :not_found
                    end
                elsif params[:region_id]
                    render json: { erreur: "Departement_id est requis" }, status: :unprocessable_entity
                else
                   render json: { erreur: "region id et departement id sont requis" }, status: :unprocessable_entity
                end
            end

            def statistics
                department = Department.find(params[:id])

                statistics = {
                    population_totale: department.localites.sum(:population_totale),
                    total_hommes: department.localites.sum(:homme),
                    total_femmes: department.localites.sum(:femme),
                    total_menages: department.localites.sum(:menage),
                    total_menageagricole: department.localites.sum(:menageagricole),
                    total_communes: department.communes.count,
                    total_localites: department.localites.count
                }

                render json: { department: department.name, statistics: statistics }
            end

            def search
                departments = Department.all
                departments = Department.joins(communes: :localites)
                          .select("departments.*, SUM(localites.population_totale) AS population")
                          .group("departments.id")

                if params[:name].present?
                    departments = departments.where("departments.name ILIKE ?", "%#{params[:name]}%")
                end

                if params[:population_totale].present?
                    departments = departments.having("SUM(localites.population_totale) >= ?", params[:population_totale].to_i)
                end

                if departments.empty?
                    render json: { erreur: "Aucun département ne correspond aux critères" }, status: :not_found
                else
                    render json: departments.map { |departments| departments.attributes.merge(population: departments.population.to_i) }
                end
            end
        end
    end
end
