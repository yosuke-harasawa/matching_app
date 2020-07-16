class AddIndexToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_index :notifications, :room_id
  end
end
