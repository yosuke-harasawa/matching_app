class MessageMailer < ApplicationMailer

  def message_notification(reciever, sender, chat_room_id)
    @reciever = reciever
    @sender = sender
    @chat_room_id = chat_room_id
    mail to: @reciever.email, subject: "You've got a new message!"
  end
end
