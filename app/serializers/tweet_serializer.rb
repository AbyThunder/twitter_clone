class TweetSerializer < ActiveModel::Serializer
  attributes :id, :content, :user_id

  belongs_to :user, each_serializer: UserSerializer
  
end
