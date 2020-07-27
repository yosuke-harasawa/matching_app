class MessagesController < ApplicationController
  def create
    @message = current_user.messages.create!(message_params)
    ActionCable.server.broadcast 'room_channel', message: @message.template

    @chat_room = @message.chat_room
    @chat_room.create_notification_message!(current_user, @message.id)
    chat_room_id = params[:message][:chat_room_id]
    chat_partner = ChatRoomUser.where(chat_room_id: chat_room_id).where.not(user_id: current_user.id).first
    reciever = User.find_by(id: chat_partner.user_id)
    return unless reciever.message_notification

    sender = current_user
    Message.send_notification_email(reciever, sender, chat_room_id)
  end

  private

  def message_params
    params.require(:message).permit(:content, :chat_room_id)
  end
end
