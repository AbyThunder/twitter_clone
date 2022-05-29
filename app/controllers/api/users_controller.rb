module Api
  class UsersController < Api::ApplicationController
    before_action :authorize_request, except: :create
    

    def index
      render json: User.all, include: '' # %w[user user.tweets] == ["user", "user.tweets"]
    end

    def show
      @user = User.find(params[:id])
      render json: @user, include: '**'
    end

    def create
      @user = User.new(user_params)

      if @user.save
        render json: @user, status: :created
      else
        render json: @user.errors.full_messages, status: :unprocessable_entity
      end
    end

    def update
      @user = User.find(params[:id])
      
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors.full_messages, status: :unprocessable_entity
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      render json: @user
    end

    private

    def user_params
      params.require(:user).permit(:name, :handle, :bio, :email, :password, :password_confirmation)
    end
  end
end
