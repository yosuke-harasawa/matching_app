class Message < ApplicationRecord
  belongs_to :chat_room
  belongs_to :user
  has_one    :notification
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 500 }
  
  def template
    ApplicationController.renderer.render partial: 'messages/message', locals: { message: self }
  end
  
  def self.send_notification_email(reciever, sender, chat_room_id)
    MessageMailer.message_notification(reciever, sender, chat_room_id).deliver_now
  end
end
