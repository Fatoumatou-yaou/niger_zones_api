class Region < ApplicationRecord

    has_many :departments, dependent: :destroy
    has_many :communes, through: :departments
    has_many :localites, through: :communes

    scope :by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }

end
