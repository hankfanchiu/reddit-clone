class SessionsController < ApplicationController
  before_action :prevent_if_logged_in, only: [:new, :create]
  before_action :require_login!, only: :destroy

  def new
    @user = User.new
    render :login
  end

  def create
    name, password = user_params[:user_name], user_params[:password]
    @user = User.find_by_credentials(name, password)
    if @user
      login_user!(@user)
      redirect_to user_url
    else
      flash[:errors] = ["Login Failed..."]
      redirect_to new_session_url
    end
  end

  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to new_session_url
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
