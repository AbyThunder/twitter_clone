class UsersController < ApplicationController
  before_action :authorize_user, except: %i[create new]
  #http_basic_authenticate_with name: "ab", password: "ab21", except: :index

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user), notice: "Successfully created account"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def user_params
    params.require(:user).permit(:name, :handle, :bio, :email, :password, :password_confirmation)
  end
end
