class CreateLocalites < ActiveRecord::Migration[8.0]
  def change
    create_table :localites do |t|
      t.string :name
      t.references :commune, null: false, foreign_key: true

      t.timestamps
    end
  end
end
