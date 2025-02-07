class AddMilieuToLocalite < ActiveRecord::Migration[8.0]
  def change
    add_column :localites, :milieu, :integer
  end
end
