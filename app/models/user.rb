class User < ActiveRecord::Base
  has_secure_password

  # Setup accessible (or protected) attributes for your model
  validates :username, presence: true, uniqueness: true
  has_many :gif_posts
  has_many :favorites
end
