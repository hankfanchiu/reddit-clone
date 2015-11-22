class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def login_user!(user)
    token = user.reset_session_token!
    session[:session_token] = token
  end

  def logout!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def current_user
    token = session[:session_token]
    @current_user ||= User.find_by(session_token: token)
  end

  def logged_in?
    !current_user.nil?
  end

  private

  def prevent_if_logged_in
    redirect_to subs_url if logged_in?
  end
end
