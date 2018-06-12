class AddRowToBurrito < ActiveRecord::Migration
  def change
    add_column :burritos, :quantity, :number
  end
end
