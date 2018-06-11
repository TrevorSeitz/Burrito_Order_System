class Burrito <ActiveRecord::Base
  belongs_to :order

  validates_presence_of :name

  def slug
    self.name.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    Burrito.all.find{|burrito| burrito.slug == slug}
  end
end