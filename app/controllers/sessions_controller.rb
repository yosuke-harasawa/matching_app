class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      params[:session][:remember_me] == '1' ? save_info_in_cookies(user) : delete_info_in_cookies(user)
      redirect_to user
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end  
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
