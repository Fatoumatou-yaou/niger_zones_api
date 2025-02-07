require 'swagger_helper'

RSpec.describe 'API V1 Regions', type: :request do
  # Endpoint: GET /api/v1/regions
  path '/api/v1/regions' do
    get 'Liste toutes les régions' do
      tags 'Regions'
      produces 'application/json'
      description 'Récupère une liste de toutes les régions du Niger. Chaque région inclut des détails comme son nom, sa population et ses départements associés.'

      parameter name: :page, in: :query, type: :integer, description: 'Numéro de page (pagination)'
      parameter name: :population_totale, in: :query, type: :integer, description: 'Population totale de la region'

      response '200', 'Liste des régions retournée avec succès' do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  region_code: { type: :integer }
                }
              }
            },
            meta: {
              type: :object,
              properties: {
                total: { type: :integer },
                page: { type: :integer },
                per_page: { type: :integer }
              }
            }
          },
          required: %w[data meta]

        let(:page) { 1 }
        let(:per_page) { 10 }
        run_test!
      end

      response '500', 'Erreur interne du serveur' do
        schema '$ref' => '#/components/responses/InternalServerError'
        run_test!
      end
    end
  end

  # Endpoint: GET /api/v1/regions/{id}
  path '/api/v1/regions/{id}' do
    get 'Récupère les détails d’une région' do
      tags 'Regions'
      produces 'application/json'
      description 'Permet de récupérer les détails d’une région spécifique en utilisant son ID. Les informations incluent son nom, ses départements associés...'

      parameter name: :id, in: :path, type: :integer, required: true, description: 'ID de la région'

      response '200', 'Détails de la région retournés avec succès' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            region_code: { type: :integer },
            departments: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string }
                }
              }
            }
          },
          required: %w[id name population_totale departments]

        let(:id) { 1 }
        run_test!
      end

      response '404', 'Ressource introuvable' do
        schema '$ref' => '#/components/responses/NotFound'
        let(:id) { 'invalid' }
        run_test!
      end

      response '500', 'Erreur interne du serveur' do
        schema '$ref' => '#/components/responses/InternalServerError'
        run_test!
      end
    end
  end

  # Endpoint: GET /api/v1/regions/{id}/statistics
  path '/api/v1/regions/{id}/statistics' do
    get 'Récupère les statistiques d’une région' do
      tags 'Regions'
      produces 'application/json'
      description 'Retourne les statistiques spécifiques à une région, comme la population totale, le nombre de menages ou d’autres indicateurs.'

      parameter name: :id, in: :path, type: :integer, required: true, description: 'ID de la région'

      response '200', 'Statistiques de la région retournées avec succès' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            population_totale: { type: :integer },
            total_hommes: { type: :integer },
            total_femmes: { type: :integer },
            total_menages: { type: :integer },
            total_menageagricole: { type: :integer },
            total_departments: { type: :integer },
            total_communes: { type: :integer },
            total_localites: { type: :integer }
          },
          required: %w[id name population_totale total_hommes total_femmes total_menages
          total_menageagricole total_departments total_communes total_localites]

        let(:id) { 1 }
        run_test!
      end

      response '404', 'Ressource introuvable' do
        schema '$ref' => '#/components/responses/NotFound'
        let(:id) { 'invalid' }
        run_test!
      end

      response '500', 'Erreur interne du serveur' do
        schema '$ref' => '#/components/responses/InternalServerError'
        run_test!
      end
    end
  end

  # Endpoint: GET /api/v1/search/regions
  path '/api/v1/search/regions' do
    get 'Recherche des régions avec filtres' do
      tags 'Regions'
      produces 'application/json'
      description 'Permet de rechercher des régions en appliquant des filtres comme le nom ou des statistiques spécifiques.'

      parameter name: :name, in: :query, type: :string, description: 'Filtrer par nom de région'
      parameter name: :population_totale, in: :query, type: :integer, description: 'Filtrer par population totale minimale'

      response '200', 'Régions filtrées retournées avec succès' do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  population_totale: { type: :integer }
                }
              }
            },
            meta: {
              type: :object,
              properties: {
                total: { type: :integer },
                page: { type: :integer },
                per_page: { type: :integer }
              }
            }
          },
          required: %w[data meta]

        let(:name) { 'Agadez' }
        run_test!
      end

      response '500', 'Erreur interne du serveur' do
        schema '$ref' => '#/components/responses/InternalServerError'
        run_test!
      end
    end
  end
end
