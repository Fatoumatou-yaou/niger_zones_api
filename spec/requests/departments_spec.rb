require 'swagger_helper'

RSpec.describe 'API V1 Departments', type: :request do
  # Endpoint: GET /api/v1/regions/{region_id}/departments
  path '/api/v1/regions/{region_id}/departments' do
    get 'Récupérer tous les départements d’une région' do
      tags 'Departments'
      produces 'application/json'
      description 'Récupère une liste de tous les départements associés à une région spécifique, avec leurs détails et leurs communes associées.'

      parameter name: :region_id, in: :path, type: :integer, required: true, description: 'ID de la région'

      response '200', 'Départements récupérés avec succès' do
        schema type: :object,
          properties: {
            departments: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  department_code: { type: :integer },
                  communes: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        id: { type: :integer },
                        name: { type: :string },
                        commune_code: { type: :integer }
                      },
                      required: %w[id name commune_code]
                    }
                  }
                },
                required: %w[id name department_code communes]
              }
            }
          }

        let(:region_id) { Region.create(name: 'Region A').id }
        run_test!
      end

      response '404', 'Ressource introuvable' do
        schema '$ref' => '#/components/responses/NotFound'
        let(:region_id) { 'invalid' }
        run_test!
      end

      response '500', 'Erreur interne du serveur' do
        schema '$ref' => '#/components/responses/InternalServerError'
        run_test!
      end
    end
  end

  # Endpoint: GET /api/v1/departments/{id}
  path '/api/v1/regions/{region_id}/departments/{id}' do
    get 'Récupérer les détails d’un département' do
      tags 'Departments'
      produces 'application/json'
      description 'Permet de récupérer les détails d’un département spécifique en utilisant son ID, y compris les communes associées.'

      parameter name: :id, in: :path, type: :integer, required: true, description: 'ID du département'

      response '200', 'Détails du département retournés avec succès' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            department_code: { type: :integer },
            communes: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  commune_code: { type: :integer }
                }
              }
            }
          },
          required: %w[id name department_code communes]

        let(:id) { Department.create(name: 'Department A', region: Region.create(name: 'Region A')).id }
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

  # Endpoint: GET /api/v1/search/departments
  path '/api/v1/departments' do
    get 'Récupérer la liste de tous les départements' do
      tags 'Departments'
      produces 'application/json'
      description 'Récupère la liste de tous les départements sans passer par une  région spécifique, avec leurs détails et leurs communes associées.' do
      response '200', 'Départements récupérés avec succès' do
        schema type: :object,
          properties: {
            departments: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  department_code: { type: :integer },
                  communes: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        id: { type: :integer },
                        name: { type: :string },
                        commune_code: { type: :integer }
                      },
                      required: %w[id name commune_code]
                    }
                  }
                },
                required: %w[id name department_code communes]
              }
            }
          }

        let(:region_id) { Region.create(name: 'Region A').id }
        run_test!
      end

      response '404', 'Ressource introuvable' do
        schema '$ref' => '#/components/responses/NotFound'
        let(:region_id) { 'invalid' }
        run_test!
      end

      response '500', 'Erreur interne du serveur' do
        schema '$ref' => '#/components/responses/InternalServerError'
        run_test!
      end
    end
  end

  # Endpoint: GET /api/v1/departments/:id/statistics
  path '/api/v1/departments/{id}/statistics' do
    get 'Récupérer les statistiques pour un département spécifique' do
      tags 'Departments'
      produces 'application/json'
      description 'Permet de récupérer les statistiques associées à un département spécifique en utilisant son ID.'

      parameter name: :id, in: :path, type: :integer, required: true, description: 'ID du département'

      response '200', 'Statistiques du département retournées avec succès' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            statistics: {
              type: :object,
              properties: {
                population_totale: { type: :integer },
                total_hommes: { type: :integer },
                total_femmes: { type: :integer },
                total_menages: { type: :integer },
                total_menageagricole: { type: :integer },
                total_communes: { type: :integer },
                total_localites: { type: :integer }
              },
              required: %w[population total_hommes total_femmes total_menages total_menageagricole total_communes total_localites]
            }
          },
          required: %w[id name statistics]

        let(:id) { Department.create(name: 'Department A', region: Region.create(name: 'Region A')).id }
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

  # Endpoint: GET /api/v1/departments/:department_id/localites
  path '/api/v1/departments/{department_id}/localites' do
    get 'Lister les localités d’un département spécifique' do
      tags 'Localites'
      produces 'application/json'
      description 'Récupère une liste de toutes les localités associées à un département spécifique, en utilisant son ID.'

      parameter name: :department_id, in: :path, type: :integer, required: true, description: 'ID du département'

      response '200', 'Localités récupérées avec succès' do
        schema type: :object,
          properties: {
            localites: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  localite_code: { type: :string },
                  localite_num: { type: :string },
                  typelocalite: { type: :integer },
                  milieu: { type: :integer },
                  homme: { type: :integer },
                  femme: { type: :integer },
                  population_totale: { type: :integer },
                  menage: { type: :integer },
                  menageagricole: { type: :integer },
                  long_degre: { type: :number, format: :float },
                  lat_degre: { type: :number, format: :float }
                },
                required: %w[id name localite_code population]
              }
            }
          }

        let(:department_id) { Department.create(name: 'Department B', region: Region.create(name: 'Region A')).id }
        run_test!
      end

      response '404', 'Ressource introuvable' do
        schema '$ref' => '#/components/responses/NotFound'
        let(:department_id) { 'invalid' }
        run_test!
      end

      response '500', 'Erreur interne du serveur' do
        schema '$ref' => '#/components/responses/InternalServerError'
        run_test!
      end
    end
  end
 end
end
