class AddCodeToLocalite < ActiveRecord::Migration[8.0]
  def change
    add_column :localites, :localite_code, :string
    add_column :localites, :localite_num, :string
  end
end
