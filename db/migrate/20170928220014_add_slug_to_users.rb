class AddSlugToUsers < ActiveRecord::Migration[5.1]
  def self.up
    add_column :users, :slug, :string

    # must make sure they are unique before adding them,
    # so that if usernames 'ged-lee' and 'ged.lee' exist
    # then 'ged.lee' must be changed to 'ged-lee-1'
    User.reset_column_information
    User.all.each do |user|
      current_slug = user.username.parameterize
      i = 0
      while User.where(slug: current_slug).exists? do
        current_slug = "#{current_slug}-#{i += 1}"
      end
      user.update_column(:slug, current_slug)
    end

    change_column :users, :slug, :string, null: false
    add_index :users, :slug, unique: true
  end

  def self.down
    remove_index :users, :slug
    remove_column :movies, :slug
  end
end
