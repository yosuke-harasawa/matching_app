# Preview all emails at http://localhost:3000/rails/mailers/message_mailer
class MessageMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/message_mailer/message_notification
  def message_notification
    reciever = User.first
    sender = User.second
    chat_room_id = 1
    MessageMailer.message_notification(reciever, sender, chat_room_id)
  end

end
