class AddMenageagricoleToLocalite < ActiveRecord::Migration[8.0]
  def change
    add_column :localites, :menageagricole, :integer
    add_column :localites, :typelocalite, :integer
  end
end
