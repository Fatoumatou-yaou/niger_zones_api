class LocaliteSerializer < ActiveModel::Serializer
  attributes :id, :name, :localite_code, :localite_num, :typelocalite, :milieu, :homme, :femme, :population_totale, :menage, :menageagricole, :long_degre, :lat_degre

  belongs_to :commune
end
