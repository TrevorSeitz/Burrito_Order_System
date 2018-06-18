class Order <ActiveRecord::Base
  belongs_to :store
  has_many :order_burritos
  has_many :burritos, through: :order_burrito

  validates_presence_of :store_id, :user_id

end