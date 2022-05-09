module Api
  class LikesController < ::ApplicationController
    skip_forgery_protection

    def create
      tweet = Tweet.find(params[:tweet_id])
      @like = tweet.likes.new(user_id: params[:user_id])
      # @like = Like.new(params.require(:like).permit(:tweet_id, :user_id))

      if @like.save
        render json: @like, status: :created
      else
        render json: @like.errors.full_messages, status: :unprocessable_entity
      end
    end

    def destroy
      @like = Like.find_by!(user_id: params[:user_id], tweet_id: params[:tweet_id])
      @like.destroy
      render json: @like
    end
  end
end
