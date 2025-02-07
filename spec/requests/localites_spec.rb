require 'swagger_helper'

RSpec.describe 'API V1 Localites', type: :request do

  # Endpoint: GET /api/v1/regions/{region_id}/departments/{department_id}/communes/{commune_id}/localites
  path '/api/v1/regions/{region_id}/departments/{department_id}/communes/{commune_id}/localites' do
    get 'Récupérer toutes les localités d’une commune' do
      tags 'Localites'
      produces 'application/json'
      description 'Permet de récupérer toutes les localités associées à une commune spécifique.'

      parameter name: :region_id, in: :path, type: :integer, required: true, description: 'ID de la région'
      parameter name: :department_id, in: :path, type: :integer, required: true, description: 'ID du département'
      parameter name: :commune_id, in: :path, type: :integer, required: true, description: 'ID de la commune'
      parameter name: :name, in: :query, type: :string, description: 'Nom de la localité ou du quartier'

      response '200', 'Localités récupérées avec succès' do
        schema type: :object,
               properties: {
                 localities: {
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
                     required: %w[id name commune_id]
                   }
                 }
               }

        let!(:region) { Region.create(name: 'Region A') }
        let!(:department) { Department.create(name: 'Department A', region: region) }
        let!(:commune) { Commune.create(name: 'Commune A', department: department) }
        let!(:locality) { Locality.create(name: 'Locality A', commune: commune, localite_code: '001') }

        run_test! do |response|
          data = JSON.parse(response.body)

          # Vérifier que les localités appartiennent à la commune
          locality_data = data['localities'].first
          expect(locality_data['commune_id']).to eq(commune.id)
        end
      end

      response '404', 'Ressource introuvable' do
        schema '$ref' => '#/components/responses/NotFound'
        let(:commune_id) { 'invalid' }
        run_test!
      end

      response '500', 'Erreur interne du serveur' do
        schema '$ref' => '#/components/responses/InternalServerError'
        run_test!
      end
    end
  end

  # Endpoint: GET /api/v1/localites/{id}
  path '/api/v1/regions/{region_id}/departments/{department_id}/communes/{commune_id}/localites/{localite_id}' do
    get 'Récupérer une localité spécifique' do
      tags 'Localites'
      produces 'application/json'
      description 'Permet de récupérer les détails d’une localité spécifique grâce à son ID.'
      
      parameter name: :region_id, in: :path, type: :integer, required: true, description: 'ID de la région'
      parameter name: :department_id, in: :path, type: :integer, required: true, description: 'ID du département'
      parameter name: :commune_id, in: :path, type: :integer, required: true, description: 'ID de la commune'
      parameter name: :id, in: :path, type: :integer, required: true, description: 'ID de la localité'

      response '200', 'Localité récupérée avec succès' do
        schema type: :object,
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
               required: %w[id name localite_code]

        let!(:locality) { Locality.create(name: 'Locality A', localite_code: '001', long_degre: 13.23, lat_degre: -1.23) }
        let(:id) { locality.id }

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

end
