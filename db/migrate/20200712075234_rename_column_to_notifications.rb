class RenameColumnToNotifications < ActiveRecord::Migration[5.2]
  def change
    rename_column :notifications, :visitted_id, :visited_id
    rename_column :notifications, :room_id, :chat_room_id
  end
end
