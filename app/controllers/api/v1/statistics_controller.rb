module Api
    module V1
      class StatisticsController < ApplicationController
        def index
          # Utiliser le cache pour stocker les statistiques globales pendant un an
          statistics = Rails.cache.fetch("global_statistics", expires_in: 1.year) do
            {
              total_population: Localite.sum(:population_totale),
              total_menages: Localite.sum(:menage),
              total_regions: Region.count,
              total_departments: Department.count,
              total_communes: Commune.count,
              total_localites: Localite.count
            }
          end
          render json: { statistics: statistics }
        end
      end
    end
end
