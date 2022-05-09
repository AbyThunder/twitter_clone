module Api
  class FollowingsController < ::ApplicationController
    skip_forgery_protection

    def show
      user = User.find(params[:user_id])
      
      render json: user.followers#, include: '' 
    end

    def create
      @following = Following.new(params.require(:following).permit(:user_id, :follower_id))

      if @following.save
        render json: @following, status: :created
      else
        render json: @following.errors.full_messages, status: :unprocessable_entity
      end
    end

    def destroy
      # Following.find(non_existing_id) # => NotFoundError
      @following = Following.find_by!(user_id: params[:user_id], follower_id: params[:follower_id])
      @following.destroy
      render json: @following
    end
  end
end
