module Api
  class LikesController < ApplicationController
    #skip_forgery_protection

    before_action :authorize_request

    def create
      tweet = Tweet.find(params[:tweet_id])
      @like = tweet.likes.new(user: @current_user)
      # @like = Like.new(params.require(:like).permit(:tweet_id, :user_id))

      if @like.save
        render json: @like, status: :created
      else
        render json: @like.errors.full_messages, status: :unprocessable_entity
      end
    end

    def destroy
      @like = Like.find_by!(user_id: @current_user.id, tweet_id: params[:tweet_id])
      @like.destroy
      render json: @like
    end
  end
end
