class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def current_user
    token = session[:session_token]
    @current_user ||= User.find_by(session_token: token)
  end

  def login_user!(user)
    token = user.reset_session_token!
    session[:session_token] = token
  end

  def logout!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def logged_in?
    !!current_user
  end

  private

  def prevent_if_logged_in
    redirect_to subs_url if logged_in?
  end

  def require_login!
    redirect_to new_session_url unless logged_in?
  end

  def vote(value)
    type = controller_name.classify
    id = params[:id]

    voted = current_user.votes.find_by(votable_id: id, votable_type: type)

    if voted
      voted.update(value: value)
    else
      attributes = { votable_id: id, votable_type: type, value: value }
      current_user.votes.create!(attributes)
    end
  end
end
