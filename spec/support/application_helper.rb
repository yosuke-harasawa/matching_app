module ApplicationHelpers
  
  def is_logged_in?
    !session[:user_id].nil?
  end
  
  def log_in_as(user)  
    get login_path
    post login_path, params: { 
      session: {
        email:    user.email,
        password: user.password
      }
    }
  end  

end  