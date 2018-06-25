class Store <ActiveRecord::Base
  has_many :users 
  has_many :orders
  has_many :burritos, through: :orders

  validates_presence_of :store_name

end