class AddEmailAndRenameUserNameToUsers < ActiveRecord::Migration
  def change
    rename_column :users, :user_name, :username
    add_column :users, :email, :string
    add_column :users, :name, :string

    User.update_all(email: :username, name: "Hank Fanchiu")

    change_column :users, :email, :string, null: false
    change_column :users, :name, :string, null: false

    add_index :users, :name
    add_index :users, :email
  end
end
