class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :store_name
      t.string :address
      t.string :phone_number
      t.integer :users_ids
      t.integer :order_ids
    end
  end
end
