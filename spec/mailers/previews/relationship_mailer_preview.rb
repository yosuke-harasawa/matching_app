# Preview all emails at http://localhost:3000/rails/mailers/relationship_mailer
class RelationshipMailerPreview < ActionMailer::Preview
  def follower_notification
    user = User.first
    follower = User.second
    RelationshipMailer.follower_notification(user, follower)
  end
end
