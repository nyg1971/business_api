# frozen_string_literal: true

class AddStatusAndDepartmentTypeToDepartments < ActiveRecord::Migration[7.2]
  def change
    add_column :departments, :status, :integer
    add_column :departments, :department_type, :integer
  end
end
