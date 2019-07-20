class TokensController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  respond_to :json


  #sign in
  def get_key
    email = params[:email]
    password = params[:password]
    @user=User.find_by_email(email.downcase)
    if @user.nil?
      logger.info("User #{email} failed signin, user cannot be found.")
      render :status=>401, :json=>{:status=>"Failure",:message=>"Invalid email"}
      return
    end
    @user.ensure_authentication_token
    if not @user.valid_password?(password)
      logger.info("User #{email} failed signin, password \"#{password}\" is invalid")
      render :status=>401, :json=>{:status=>"Failure",:message=>"Invalid password."}
    else
      render :status=>200, :json=>{:status=>"Success", :auth_token=>@user.authentication_token, :key => @user.secret_key, :user=>@user.id}
    end
  end
  
  # sign_up
  def user_sign_up
    @user = User.new({:name => params[:name],
                      :email => params[:email],
                      :password => params[:password],
                      :password_confirmation => params[:password_confirmation]
                     })
    if @user.save
     render :status => 200, :json => { :status=>"Success", :auth_token=>@user.authentication_token, :key => @user.secret_key, :user=>@user.id, :message => []}
     return true
    else
      errors = []
      errors << "Error while uploading :"
      @user.errors.each do |x, t|
        errors << "#{x.to_s.gsub('_', ' ')} : #{t}"
      end
      logger.info @user.errors.inspect
      render :status => 200, :json => { :status=>"Failure",:message=> errors}
    end
  end

  def destroy_token
    key = params[:key].presence
    user = key && User.find_by_secret_key(key)
    if user.nil?
      render :status=>401, :json=>{:status=>"Failure",:message=>"Invalid Key."}
      return
    end
    if user and user.authentication_token.present? and (user.authentication_token == params[:auth_token])
      user.update_column(:auth_token, nil)
      render :status=>200, :json=>{:status=>"Success",:message=>"Authentication token set to nil"}
    else
      render :status=>401, :json=>{:status=>"Failure",:message=>"Invalid Authentication token."}
      return
    end
  end

  
 
end
