class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ApplicationHelper


  def authenticate_user
    if session[:user_id].blank?
      return redirect_to new_session_path
    end
  end

end
