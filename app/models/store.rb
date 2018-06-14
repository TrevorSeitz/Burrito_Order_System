class Store <ActiveRecord::Base
  has_many :user #or belongs_to?
  has_many :orders, through: :order_burrito
  has_many :burritos, through: :order_burrito

  validates_presence_of :store_name

  def slug
    self.store_name.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    Store.all.find{|store| store.slug == slug}
  end
end