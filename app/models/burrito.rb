class Burrito <ActiveRecord::Base
  has_many :order_burritos
  has_many :orders, through: :order_burritos

  validates_presence_of :name, :description, :price

end