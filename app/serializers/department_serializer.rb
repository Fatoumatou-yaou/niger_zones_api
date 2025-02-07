class DepartmentSerializer < ActiveModel::Serializer
  attributes :id, :name, :department_code

  belongs_to :region, embed: :ids
  
  has_many :communes
end
