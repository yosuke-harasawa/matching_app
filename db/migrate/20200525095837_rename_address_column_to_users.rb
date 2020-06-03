class RenameAddressColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :address, :prefecture_code
  end
end
