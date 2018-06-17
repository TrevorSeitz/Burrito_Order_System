class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :store_id
      t.integer :user_id
      t.decimal :order_total
    end
  end
end
