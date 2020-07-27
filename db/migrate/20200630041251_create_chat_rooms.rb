class CreateChatRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_rooms, &:timestamps
  end
end
