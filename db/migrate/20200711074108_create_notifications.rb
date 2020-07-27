class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id,  null: false
      t.integer :visitted_id, null: false
      t.string  :action,      default: '', null: false
      t.boolean :checked,     default: false, null: false
      t.timestamps
    end

    add_index :notifications, :visitor_id
    add_index :notifications, :visitted_id
  end
end
