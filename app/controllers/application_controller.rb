class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :sort_by_votes, :admin?

  def sort_by_votes(collection)
    collection.sort_by{|obj| -obj.total_votes}
  end

  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
  	!!current_user
  end

  def admin?
    logged_in? and current_user.admin?
  end

  def require_user
    not_logged_in unless logged_in?
  end

  def require_admin
    access_denied unless admin?
  end

  def access_denied
    flash[:error] = "You can't do that."
    redirect_to root_path
  end
  def not_logged_in
    flash[:error] = "You must log in to do that."
    redirect_to root_path
  end
end
