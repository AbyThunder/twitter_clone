class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :handle, :bio, :email

  has_many :tweets, each_serializer: TweetSerializer
end
