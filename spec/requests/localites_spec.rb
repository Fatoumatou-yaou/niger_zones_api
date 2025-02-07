require 'swagger_helper'

RSpec.describe 'API V1 Localites', type: :request do
  # Endpoint: GET /api/v1/regions/{region_id}/departments/{department_id}/communes/{commune_id}/localites
  require 'swagger_helper'

  require 'swagger_helper'

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
                     }
                   }
                 }
               }

        let!(:region) { Region.create!(name: 'Region A') }
        let!(:department) { Department.create!(name: 'Department A', region: region) }
        let!(:commune) { Commune.create!(name: 'Commune A', department: department) }
        let!(:localite) { Localite.create!(name: 'Localite A', commune_id: commune.id, localite_code: '001') }

        let(:region_id) { region.id }
        let(:department_id) { department.id }
        let(:commune_id) { commune.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['localites']).not_to be_empty
          expect(data['localites'].first['commune_id']).to eq(commune.id)
        end
      end

      response '404', 'Ressource introuvable' do
        let(:region_id) { 999 }
        let(:department_id) { 999 }
        let(:commune_id) { 999 }
        run_test!
      end

      response '500', 'Erreur interne du serveur' do
        before do
          allow(Localite).to receive(:where).and_raise(StandardError)
        end

        let(:region_id) { 1 }
        let(:department_id) { 1 }
        let(:commune_id) { 1 }

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
