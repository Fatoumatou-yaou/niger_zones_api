class Commune < ApplicationRecord
  belongs_to :department
  has_many :localites, dependent: :destroy

  scope :by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }
end
