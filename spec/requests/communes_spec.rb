require 'swagger_helper'
RSpec.describe 'Communes', type: :request do
  path '/api/v1/regions/#{region_id}/departments/#{department_id}/communes' do
    get 'Recuperer toutes les communes' do
      tags 'Communes'
      produces 'application/json'

      response '200', 'Communes recuperees avec succès' do
        schema type: :object,
               properties: {
                 communes: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string },
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
                           required: %w[id name commune_id]
                         }
                       }
                     },
                     required: %w[id name department_id localities]
                   }
                 }
               }

        let!(:region) { Region.create(name: 'Region A') }
        let!(:department) { Department.create(name: 'Department A', region: region) }
        let!(:commune) { Commune.create(name: 'Commune A', department: department) }
        let!(:localite) { Localite.create(name: 'Localite A', commune: commune) }
        let(:region_id) { region.id }
        let(:department_id) { department.id }

        run_test! do |response|
          data = JSON.parse(response.body)

          # Vérifier que communes belongs to department
          commune_data = data['communes'].first
          expect(commune_data['department_id']).to eq(department.id)

          # Vérifier que commune a bien ses localites
          localites_data = commune_data['localites']
          expect(localites_data.size).to eq(1)
          expect(localites_data.first['id']).to eq(localite.id)
          expect(localites_data.first['commune_id']).to eq(commune.id)
        end
      end
      response '404', 'Ressource introuvable', ref: '#/components/responses/NotFound'

      response '500', 'Erreur interne du serveur', ref: '#/components/responses/InternalServerError'
    end
  end
end
