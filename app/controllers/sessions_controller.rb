class SessionsController < ApplicationController

  def sign_out
    session[:user_id] = nil
    return redirect_to root_path
  end

  def create
    user = User.where('email = ?', params[:email]).first
    if user.present? and user.valid_password?(params[:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      @error = 'Invalid Credentials'
      render 'sessions/new'
    end
  end

end
