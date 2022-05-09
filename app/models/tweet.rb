class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes
  has_many :liking_users, through: :likes, source: :user
  validates :content, presence: true

  def self.create_with_handle(content:, handle:)
    user = User.find_by(handle: handle)

    Tweet.create(content: content, user: user)
  end

  # scope :tweet_order, -> { order(created_at: :asc) }
  # scope :tweet_like_order, -> (id) { where(id: id).order(count(id.likes)) }
end
