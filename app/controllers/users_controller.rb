class UsersController < ApplicationController
  before_action :prevent_if_logged_in, only: [:new, :create]
  before_action :require_login!, only: :show

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login_user!(@user)
      redirect_to user_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def show
    @user = current_user
    render :show
  end

  def update
    @user = current_user

    if @user.is_password?(user_params[:password])
      attributes = {
        name: user_params[:name],
        email: user_params[:email],
        password: user_params[:password],
        password_confirmation: user_params[:password_confirmation]
      }

      if @user.update(attributes)
        flash[:success] = ["Profile updated!"]
        redirect_to user_url
      else
        flash.now[:errors] = @user.errors.full_messages
        render :show
      end
    else
      flash.now[:errors] = ["Update failed"]
      render :show
    end
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
