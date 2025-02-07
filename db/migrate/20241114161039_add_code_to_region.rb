class AddCodeToRegion < ActiveRecord::Migration[8.0]
  def change
    add_column :regions, :region_code, :string
  end
end
