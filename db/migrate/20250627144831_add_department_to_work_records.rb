class AddDepartmentToWorkRecords < ActiveRecord::Migration[7.2]
  def change
    add_reference :work_records, :department, null: false, foreign_key: true
  end
end
