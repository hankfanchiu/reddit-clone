class SessionsController < ApplicationController
  before_action :prevent_if_logged_in, only: [:new, :create]
  before_action :require_login!, only: :destroy

  def new
    @user = User.new
    render :login
  end

  def create
    name, password = user_params[:username], user_params[:password]
    @user = User.find_by_credentials(name, password)
    if @user
      login_user!(@user)
      redirect_to user_url
    else
      flash[:errors] = ["Login Failed!"]
      redirect_to new_session_url
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end

  private

  def user_params
    params.require(:user).permit(
      :username,
      :name,
      :email,
      :password,
      :password_confirmation
      )
  end
end
