module Api
  class UsersController < ::ApplicationController
    skip_forgery_protection

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
      # User.find_by(any_field: value)
      # VS 
      # User.find(id)
      @user = User.find(params[:id])
      
      # user = User.last
      # user.update(name: "New")
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
      params.require(:user).permit(:name, :handle, :bio, :email)
    end
  end
end

=begin
{
  "user": {
    "name": "Super Cool Name"
  }
}
=end