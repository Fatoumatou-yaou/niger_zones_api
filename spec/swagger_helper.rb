# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Niger zones API',
        version: 'v1',
        description: 'L\'API permet d\'accéder aux données géographiques du Niger, organisées en régions, départements, communes et localités/quartiers. Elle est conçue pour les développeurs souhaitant intégrer ces données dans leurs applications.

           Limites d’utilisation :
            - Maximum :   50 requêtes par minute par IP
            - Réponse 429 (Trop de requetes) si la limite est dépassée.

            Pagination
            Utilisez `page` comme paramètres de requête pour gérer la pagination :

              ```
              GET /api/v1/regions?page=2
              ```

            Questions Fréquentes
              1. Comment filtrer les données ?
              Utilisez les paramètres de requête tels que `population_totale` ou `name` pour filtrer les résultats.

              2. Que faire en cas d’erreur 404 ?
              Vérifiez si l’ID ou les paramètres fournis sont corrects.

              3. Quels formats de réponse sont pris en charge ?
              Toutes les réponses sont en `application/json`.',

          contact: {
          name: 'API Support',
          email: 'fatoumatouyaou@gmail.com'
        }
      },
      # paths: {},
      components: {
        responses: {
          NotFound: {
            description: 'Ressource introuvable.',
            content: {
              'application/json' => {
                schema: {
                  type: :object,
                  properties: {
                    error: { type: :string, example: 'Ressource introuvable.' }
                  }
                }
              }
            }
          },
          InternalServerError: {
            description: 'Erreur interne du serveur.',
            content: {
              'application/json' => {
                schema: {
                  type: :object,
                  properties: {
                    error: { type: :string, example: 'Erreur interne inattendue.' }
                  }
                }
              }
            }
          },
          TooManyRequests: {
            description: 'Trop de requêtes.',
            content: {
              'application/json' => {
                schema: {
                  type: :object,
                  properties: {
                    error: { type: :string, example: 'Trop de requêtes. Réessayez plus tard.' }
                  }
                }
              }
            }
          }
        },
        schemas: {
          Region: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              region_code: { type: :string }
            },
            required: %w[id name]
          },
          Department: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              department_code: { type: :integer }
            },
            required: %w[id name]
          }
        }
      },
      paths: {},
      servers: [
        {
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'http://localhost:3000'
            }
          }
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
