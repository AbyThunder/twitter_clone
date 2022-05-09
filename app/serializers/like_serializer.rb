class LikeSerializer < ActiveModel::Serializer
  attributes :id, :tweet_id, :user_id

  belongs_to :user, each_serializer: UserSerializer
  belongs_to :tweet, each_serializer: TweetSerializer
end
