class AddIndexToCharacterization < ActiveRecord::Migration[5.1]
  def change
    add_index :characterizations, [:movie_id, :genre_id], unique: true
  end
end
