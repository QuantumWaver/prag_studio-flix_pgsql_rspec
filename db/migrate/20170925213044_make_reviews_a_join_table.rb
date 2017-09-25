class MakeReviewsAJoinTable < ActiveRecord::Migration[5.1]
  def up
    Review.delete_all
    remove_column :reviews, :name
    add_column    :reviews, :user_id, :integer
    add_index     :reviews, [:user_id, :movie_id]
  end

  def down
    Review.delete_all
    remove_index     :reviews, [:user_id, :movie_id]
    remove_column :reviews, :user_id
    add_column    :reviews, :name,  :string
  end
end
