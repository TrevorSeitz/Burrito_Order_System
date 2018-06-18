class Store <ActiveRecord::Base
  has_many :user #or belongs_to?
  has_many :orders, through: :order_burrito
  has_many :burritos, through: :order_burrito

  validates_presence_of :store_name

end