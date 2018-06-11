class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :store_id
      t.integer :user_id
      t.integer :burrito_id
      t.integer :quantity
      t.decimal :item_total
      t.decimal :order_total
    end
  end
end
