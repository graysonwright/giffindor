class GifPostSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :url, :body, :username, :current_user_favorite_id, :created_at
  has_many :favorites

  def username
    object.user.username
  end

  def current_user_favorite_id
    object.favorites.find_by(user_id: (current_user.id rescue nil)).try :id
  end
end
