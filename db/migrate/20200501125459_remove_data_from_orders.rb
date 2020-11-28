class RemoveDataFromOrders < ActiveRecord::Migration[6.0]
  def change

    remove_column :orders, :date, :date
  end
end
