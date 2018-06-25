class Order <ActiveRecord::Base
  belongs_to :store
  belongs_to :user
  has_many :order_burritos
  has_many :burritos, through: :order_burritos

  validates_presence_of :store_id, :user_id

end