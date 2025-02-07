class AddCodeToDepartment < ActiveRecord::Migration[8.0]
  def change
    add_column :departments, :department_code, :string
  end
end
