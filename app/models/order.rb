class Order <ActiveRecord::Base
  belongs_to :store
  has_many :burritos

  validates_presence_of :store, :burritos

  def slug
    self.name.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    Order.all.find{|order| order.slug == slug}
  end
end