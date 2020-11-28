class RemoveMenuItemNameFromOrderItems < ActiveRecord::Migration[6.0]
  def change
    remove_column :order_items, :menu_item_name, :string
    remove_column :order_items, :menu_item_price, :float
    add_column :order_items, :quantity, :integer
    add_column :order_items, :total, :float
    add_column :orders, :total, :float
  end
end
