class OrderBurrito < ActiveRecord::Base
  belongs_to :order
  belongs_to :burrito
end