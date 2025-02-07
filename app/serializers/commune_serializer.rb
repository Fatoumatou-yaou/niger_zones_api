class CommuneSerializer < ActiveModel::Serializer
  attributes :id, :name, :commune_code

  belongs_to :department

  has_many :localites
end
