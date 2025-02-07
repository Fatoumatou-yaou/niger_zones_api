class AddHommeToLocalite < ActiveRecord::Migration[8.0]
  def change
    add_column :localites, :population_totale, :integer
    add_column :localites, :homme, :integer
    add_column :localites, :femme, :integer
    add_column :localites, :menage, :integer
    add_column :localites, :long_degre, :float
    add_column :localites, :lat_degre, :float
  end
end
