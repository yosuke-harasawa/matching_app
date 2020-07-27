class RelationshipMailer < ApplicationMailer
  def follower_notification(user, follower)
    @user = user
    @follower = follower
    mail to: @user.email, subject: "#{@follower.name} followed you"
  end
end
