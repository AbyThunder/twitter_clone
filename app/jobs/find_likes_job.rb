class FindLikesJob < ApplicationJob
  queue_as :default

  def perform(user_id, start_date, end_date)
    require 'date'
    require 'csv'
    user = User.find(user_id)
    starting_date, ending_date = Date.parse(start_date), Date.parse(end_date)
    likes = Like.select { |like| like.tweet.user_id == user.id }
    
    CSV.open("./report.csv", 'w+') do |add|
      (starting_date..ending_date).each do |date|
        like_count = likes.select { |like| like.created_at.strftime("%d/%m/%Y") == date.strftime("%d/%m/%Y") }.count
        add << [date.strftime("%d/%m/%Y"), like_count] 
      end
    end
  end
end