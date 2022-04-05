class User < ApplicationRecord
  has_many :tweets
  has_many :likes
  has_many :liked_tweets, through: :likes, source: :tweet
end
