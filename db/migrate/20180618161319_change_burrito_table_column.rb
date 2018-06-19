class ChangeBurritoTableColumn < ActiveRecord::Migration
  def change
     change_column(:burritos, :price, :decimal, precision: 10, scale: 2)
  end
end
