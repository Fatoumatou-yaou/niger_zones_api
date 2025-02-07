class Department < ApplicationRecord
  belongs_to :region
  has_many :communes, dependent: :destroy
  has_many :localites, through: :communes

  scope :by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }
end
