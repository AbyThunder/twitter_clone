class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery with: :null_session

  def authorize_user
    unless logged_in?
      flash.alert = "Please log in."
      session[:redirected_from] = request.path
      redirect_to login_url
    end
  end
end
