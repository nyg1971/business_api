class AddStatusAndCustomerTypeToCustomers < ActiveRecord::Migration[7.2]
  def change
    add_column :customers, :status, :integer
  end
end
