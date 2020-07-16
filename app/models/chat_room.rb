class ChatRoom < ApplicationRecord
  has_many :chat_room_users
  has_many :messages
  has_many :notifications
  
  def create_notification_message!(current_user, message_id)
    chat_partner_id = ChatRoomUser.where(chat_room_id: id).where.not(user_id: current_user.id)
                   .map(&:user_id).first
    save_notification_message!(current_user, message_id, chat_partner_id)
  end 
  
  private
    
    def save_notification_message!(current_user, message_id, visited_id)
      notification = current_user.active_notifications.new(
        visited_id: visited_id,
        chat_room_id: id,
        message_id: message_id,
        action: "message"
        )
      if notification.visitor_id == notification.visited_id
        notification.checked == true
      end
      notification.save if notification.valid?
    end  
end
