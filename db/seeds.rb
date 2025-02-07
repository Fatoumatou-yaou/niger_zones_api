require 'roo'
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Charger le fichier Excel depuis db/seeds
file_path = Rails.root.join('db', 'seeds', 'RENALOC.xlsx').to_s
xlsx = Roo::Spreadsheet.open(file_path)

xlsx.each_row_streaming(offset: 1) do |row|
  # Logique pour importer les données
  region = Region.find_or_create_by(name: row[2].cell_value.to_s, region_code: row[1].to_s)
  department = Department.find_or_create_by(name: row[4].cell_value.to_s, department_code: row[3].to_s, region: region)
  commune = Commune.find_or_create_by(name: row[6].cell_value.to_s, commune_code: row[5].to_s, department: department)

  Localite.find_or_create_by(
    name: row[8].cell_value.to_s,
    commune: commune
  ).update(
    localite_code: row[0]&.value.to_i || 0,
    localite_num: row[7].cell_value.to_s,
    population_totale: row[9]&.value.to_i || 0,
    homme: row[10]&.value.to_i || 0,
    femme: row[11]&.value.to_i || 0,
    menage: row[12]&.value.to_i || 0,
    menageagricole: row[13]&.value.to_i || 0,
    long_degre: row[13]&.value.to_f || 0.0,
    lat_degre: row[17]&.value.to_f || 0.0,
    milieu: row[20]&.value.to_i || 0,
    typelocalite: row[21]&.value.to_i || 0

  )
end
