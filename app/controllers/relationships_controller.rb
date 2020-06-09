class RelationshipsController < ApplicationController
  before_action :logged_in_user
  
  def create
    user = User.find(params[:following_id])
    current_user.follow(user)
    redirect_to user
  end
end
