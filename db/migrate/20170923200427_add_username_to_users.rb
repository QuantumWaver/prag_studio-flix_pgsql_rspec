class AddUsernameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :username, :string

    # MY ADDED
    # Go through all the current users and give them
    # unique usernames based on their email
    User.reset_column_information
    User.all.each do |user|
      username = user.email.split('@').first.downcase
      i = 0
      while User.where(username: username).exists? do
        username = "#{user.email.split('@').first.downcase}#{i += 1}"
      end
      user.update_column(:username, username)
    end

    # set username to be a searchable index
    change_column :users, :username, :string, null: false
    add_index :users, :username, unique: true
  end
end
