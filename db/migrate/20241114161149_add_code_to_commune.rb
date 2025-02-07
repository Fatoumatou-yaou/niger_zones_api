class AddCodeToCommune < ActiveRecord::Migration[8.0]
  def change
    add_column :communes, :commune_code, :string
  end
end
