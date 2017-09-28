class AddSlugToMovies < ActiveRecord::Migration[5.1]
  def self.up
    # given that slugs are to be based off of the titles, and
    # that slugs must be unique, we must first ensure that all
    # titles are case insensitive unique as this was not yet enforced
    Movie.all.order(created_at: :desc).each do |movie|
      current_title = movie.title
      while (i = Movie.where('lower(title) = ?', current_title.downcase).count) > 1 do
        current_title = "#{movie.title}-#{i-1}"
      end
      movie.update_column(:title, current_title)
    end

    # Now add the slug column (not null restricted yet)
    add_column :movies, :slug, :string

    # Now create the slug based on the now unique title
    Movie.reset_column_information
    Movie.all.each do |movie|
      movie.update_column(:slug, movie.title.parameterize)
    end

    # Force the slug column to not be null and set index
    change_column :movies, :slug, :string, null: false
    add_index :movies, :slug, unique: true

    # Finally set index and force uniqueness at the db level
    # on the now unique titles
    change_column :movies, :title, :string, null: false
    add_index :movies, :title, unique: true
  end

  def self.down
    remove_index :movies, :title
    remove_index :movies, :slug

    remove_column :movies, :slug
  end

end
