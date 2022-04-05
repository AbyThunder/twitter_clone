class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes
  has_many :liking_users, through: :likes, source: :user

  def self.create_with_handle(content:, handle:)
    user = User.find_by(handle: handle)

    Tweet.create(content: content, user: user)
  end

end
