class Store <ActiveRecord::Base
  belongs_to :user
  has_many :orders

  validates_presence_of :name

  def slug
    self.name.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    Store.all.find{|store| store.slug == slug}
  end
end