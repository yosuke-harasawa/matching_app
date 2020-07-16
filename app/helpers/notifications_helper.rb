module NotificationsHelper
  def unchecked_follow_notifications
    @notifications = current_user.passive_notifications.where(action: "follow", checked: false)
  end  
  
  def unchecked_message_notifications
    @notifications = current_user.passive_notifications.where(action: "message", checked: false)
  end
  
  def unchecked_room_notifications(chat_room_id)
    @notifications = current_user.passive_notifications.where(action: "message", chat_room_id: chat_room_id, checked: false)
  end  
end