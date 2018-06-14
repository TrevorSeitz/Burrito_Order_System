class CreateOrderBurrito < ActiveRecord::Migration
  def change
    create_table :order_burrito do |t|
      t.integer :order_id
      t.integer :user_id
      t.integer :burrito_id
      t.integer :quantity
      t.integer :item_price
    end
  end
end
