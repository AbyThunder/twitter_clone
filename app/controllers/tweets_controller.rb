class TweetsController < ApplicationController
  before_action :authorize_user
  def index
    @tweets = Tweet.all
  end

  def show
    @tweet = Tweet.find(params[:id])
  end

  def new
  end

  def edit
  end
end
