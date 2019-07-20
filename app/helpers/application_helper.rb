module ApplicationHelper

  def user_signed_in?
    session[:user_id].present?
  end

  def current_user
    @user ||= User.find(session[:user_id]) if session[:user_id].present?
  end

end
