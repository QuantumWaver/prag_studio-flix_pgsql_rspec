class Genre < ApplicationRecord
  has_many :characterizations, dependent: :destroy
  has_many :movies, through: :characterizations

  scope :list_by_name, -> { order(:name) }

  validates :name, presence: true, uniqueness: { case_sensitive: false }

end
