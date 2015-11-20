class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def login_user!(user)
    token = user.reset_session_token!
    session[:session_token] = token
    current_user = user
  end

  def current_user
    token = session[:session_token]
    @current_user ||= User.find_by(session_token: token)
  end

  def logged_in?
    !current_user.nil?
  end

end
