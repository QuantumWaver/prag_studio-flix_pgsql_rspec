class Review < ApplicationRecord
  belongs_to :movie

  STARS = [1, 2, 3, 4, 5]

  validates :name, presence: true
  validates :comment, length: { minimum: 4 }
  validates :stars, inclusion: { in: STARS, message: "must be between 1 and 5" }
  validates :stars, numericality: { only_integer: true, message: "must be an integer between 1 and 5" }

end
