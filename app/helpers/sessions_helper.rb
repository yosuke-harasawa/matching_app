module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def save_info_in_cookies(user)
    user.save_hashed_token_in_db
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
      if user&.authenticated?(:remember, cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def delete_info_in_cookies(user)
    user.delete_hashed_token_in_db
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    delete_info_in_cookies(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user?(user)
    user == current_user
  end

  def store_location
    session[:fowarding_url] = request.original_url if request.get?
  end

  def redirect_back_or(default)
    redirect_to(session[:fowarding_url] || default)
    session.delete(:fowarding_url)
  end
end
