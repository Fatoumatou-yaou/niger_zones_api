module Api 
  module V1 
    class RegionsController < ApplicationController
      def index
        regions = Region.includes(departments: :communes).all
        response = {
          regions: ActiveModelSerializers::SerializableResource.new(
            regions,
            include: {
              departments: { include: :communes }
            }
          )
        }
        render json: response.as_json
      end
      
      def show
        begin
          region = Region.includes(departments: :communes).find(params[:id])
          serialized_region = ActiveModelSerializers::SerializableResource.new(region, include: ['departments.communes'])
          render json: serialized_region.as_json
        rescue ActiveRecord::RecordNotFound
          render json: { erreur: "Aucune région trouvée!" }, status: :not_found
        end
      end

      def statistics 
          region = Region.find(params[:id])

          statistics = {
              population_totale: region.localites.sum(:population_totale),
              total_hommes: region.localites.sum(:homme),
              total_femmes: region.localites.sum(:femme),
              total_menages: region.localites.sum(:menage),
              total_menageagricole: region.localites.sum(:menageagricole),
              total_departments: region.departments.count,
              total_communes: region.communes.count,
              total_localites: region.localites.count
          }

          render json: { region: region.name, statistics: statistics}
      end

      def search
          regions = Region.all
          regions = Region.joins(departments: { communes: :localites })
                          .select('regions.*, SUM(localites.population_totale) AS population')
                          .group('regions.id')
        
          if params[:name].present?
            regions = regions.where("regions.name ILIKE ?", "%#{params[:name]}%")
          end
        
          if params[:population_totale].present?
            regions = regions.having('SUM(localites.population_totale) >= ?', params[:population_totale].to_i)
          end
        
          if regions.empty?
            render json: { erreur: "Aucune région ne correspond aux critères" }, status: :not_found
          else
            render json: regions.map { |region| region.attributes.merge(population: region.population.to_i) }
          end
      end
    end
  end
end
