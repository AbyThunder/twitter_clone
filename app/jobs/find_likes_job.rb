# REVIEW: requires should be here

class FindLikesJob < ApplicationJob
  queue_as :default

  def perform(user_id, start_date, end_date)
    require 'date' # REVIEW: move requires to the top of the file :)
    require 'csv'
    user = User.find(user_id)
    starting_date, ending_date = Date.parse(start_date), Date.parse(end_date)
    likes = Like.select { |like| like.tweet.user_id == user.id } # REVIEW: Like.where(tweet: user.tweets, created_at: (start_date..end_date))
    # that works, but will be consuming a lot of RAM
    
    CSV.open("./report.csv", 'w+') do |add|
      (starting_date..ending_date).each do |date|
        # REVIEW: try to rewrite it with `where` as well
        # e.g. likes.where(created_at: (date.beginning_of_day..date.end_of_day)).count
        like_count = likes.select { |like| like.created_at.strftime("%d/%m/%Y") == date.strftime("%d/%m/%Y") }.count
        add << [date.strftime("%d/%m/%Y"), like_count] 
      end
    end
  end
end
