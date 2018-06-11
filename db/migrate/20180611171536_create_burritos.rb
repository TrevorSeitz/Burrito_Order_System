class CreateBurritos < ActiveRecord::Migration
  def change
    create_table :burritos do |t|
      t.string :name
      t.string :description
      t.decimal :price
      t.boolean :vegan
      t.boolean :gluten_free
      t.boolean :hot
    end
  end
end
