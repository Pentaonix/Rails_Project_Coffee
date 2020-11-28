class CreateMenuItems < ActiveRecord::Migration[6.0]
  def change
    create_table :menu_items do |t|
      t.integer :menu_id
      t.string :name
      t.string :description
      t.float :price
      t.timestamps
    end
  end
end
