class AddDetailsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :gender, :string
    add_column :users, :age, :integer
    add_column :users, :address, :string
    add_column :users, :nationality, :string
    add_column :users, :bio, :text
    add_column :users, :hobby, :string
    add_column :users, :job, :string
    add_column :users, :status, :string
  end
end
