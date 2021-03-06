class User <ActiveRecord::Base
  belongs_to :store
  has_many :order_burritos
  has_many :orders, through: :order_burritos

  has_secure_password

  validates_presence_of :username, :email

  def slug
    self.name.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    User.all.find{|user| user.slug == slug}
  end
end