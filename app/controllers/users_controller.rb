class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find_by(handle: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)

    redirect_to user_path(@user.handle)
  end

  def edit
  end

  def user_params
    params.require(:user).permit(:name, :handle, :bio, :email)
  end

end
