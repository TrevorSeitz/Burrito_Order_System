class AddColumnToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :total_items, :integer 
  end
end

