class Favorite < ApplicationRecord
  belongs_to :movie
  belongs_to :user

  validates :user_id, :movie_id, presence: true
end
