module Api
  class TweetsController < ::ApplicationController
    before_action :authorize_request

    def index
      render json: Tweet.all, include: 'user' # %w[user user.tweets] == ["user", "user.tweets"]

    end

    def show
      @tweet = Tweet.find(params[:id])
      render json: @tweet, include: %w[user user.tweets] 
    end

    def create
      @tweet = Tweet.new(tweet_params)

      if @tweet.save
        render json: @tweet, status: :created
      else
        render json: @tweet.errors.full_messages, status: :unprocessable_entity
      end
    end

    def update
      @tweet = Tweet.find(params[:id])

      if @tweet.update(params.require(:tweet).permit(:content))
        render json: @tweet
      else
        render json: @tweet.errors.full_messages, status: :unprocessable_entity
      end
    end

    def destroy
      @tweet = Tweet.find(params[:id])
      @tweet.destroy
      render json: @tweet
    end

    private

    def tweet_params
      params.require(:tweet).permit(:content, :user_id)
    end
  end
  
end
