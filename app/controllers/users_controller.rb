class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]
  
  def index
    query = params[:q]
    search_history = {
      value: params[:q],
    }
    if logged_in?
      query ||= eval(cookies[:recent_search_history].to_s)
      cookies[:recent_search_history] = search_history if params[:q].present?
      @q = User.ransack(query)
      @users = @q.result.where.not(id: current_user.id, activated: false).page(params[:page]).per(40)
    else
      @q = User.ransack(query)
      @users = @q.result.where(activated: true).page(params[:page]).per(40)
    end  
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit 
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Update successful!"
      redirect_to @user
    else
      render 'edit'
    end  
  end  
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end  
  
  def followers
    @title = "Friend Request"
    @user  = current_user
    @users = @user.followers
    notifications = @user.passive_notifications.where(action: "follow", checked: false)
    notifications.update(checked: true)
    render 'show_follow'
  end  
  
  def matchers
    @title = "Matching"
    @users = current_user.matching_users
    render 'show_match'
  end  
  
  private
  
    def user_params
      params.require(:user).permit(:avatar, :name, :gender, :age, :prefecture_code, 
                                   :nationality, :bio, :hobby, :job, :status, :email, 
                                   :password, :password_confirmation,
                                   :remove_avatar, :follow_notification)
    end  

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end  
    
    def admin_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user.admin? or current_user?(@user)
    end 
    
    # def matching_users
    #   User.where(id: passive_relationships.select(:follower_id)).where(id: active_relationships.select(:following_id))
    # end
    
end
