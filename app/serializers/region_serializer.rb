class RegionSerializer < ActiveModel::Serializer
  attributes :id, :name, :region_code

  has_many :departments
end
