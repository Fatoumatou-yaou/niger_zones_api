class CreateCommunes < ActiveRecord::Migration[8.0]
  def change
    create_table :communes do |t|
      t.string :name
      t.references :department, null: false, foreign_key: true

      t.timestamps
    end
  end
end
