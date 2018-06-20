class DropBurritoColumns < ActiveRecord::Migration
  def change
    remove_column :burritos, :vegan
    remove_column :burritos, :gluten_free
    remove_column :burritos, :hot
  end
end
