class User < ApplicationRecord
  has_many :tweets
  has_many :likes
  has_many :liked_tweets, through: :likes, source: :tweet
  has_many :following, class_name: 'Following', foreign_key: 'follower_id'
  has_many :followers, class_name: 'Following', foreign_key: 'user_id'

  validates :name, :handle, presence: true
  validates :handle, format: { with: /\A[\w\d_-]+\z/ }, length: { minimum: 6, maximum: 256 }
end
