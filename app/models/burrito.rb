class Burrito <ActiveRecord::Base
  has_many :order_burritos
  has_many :orders, through: :order_burrito

  validates_presence_of :name, :description, :price

  def slug
    self.name.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    Burrito.all.find{|burrito| burrito.slug == slug}
  end
end