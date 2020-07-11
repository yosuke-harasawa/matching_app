class Relationship < ApplicationRecord
  belongs_to :follower,  class_name: "User"
  belongs_to :following, class_name: "User"
  validates :follower_id,  presence: true
  validates :following_id, presence: true
  
  def self.send_notification_email(user, follower)
    RelationshipMailer.follower_notification(user, follower).deliver_now
  end  
end
