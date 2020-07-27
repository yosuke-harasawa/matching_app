class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:relationship][:following_id])
    current_user.follow(@user)
    @user.create_notification_follow!(current_user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
