class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if user.activated?
        log_in(user)
        params[:session][:remember_me] == '1' ? save_info_in_cookies(user) : delete_info_in_cookies(user)
        redirect_back_or root_url
      else
        flash[:warning] = 'Account not activated! Check your email activation link'
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
