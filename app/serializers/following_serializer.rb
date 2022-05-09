class FollowingSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :follower_id

  belongs_to :user, each_serializer: UserSerializer
end
