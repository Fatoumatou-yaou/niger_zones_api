class Localite < ApplicationRecord
  belongs_to :commune

  scope :by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }
end
