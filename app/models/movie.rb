class Movie < ApplicationRecord
  # This declaration tells Rails to expect a 'movie_id'
  # foreign key column in the table wrapped by the Review model
  has_many :reviews, dependent: :destroy

  RATINGS = %w(G PG PG-13 R NC-17)

  validates :title, :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :rating, inclusion: { in: RATINGS }
  validates :image_file_name, allow_blank: true, format: {
    with:    /\w+\.(gif|jpg|png)\z/i,
    message: "must reference a GIF, JPG, or PNG image"
  }

  # CLASS METHODS
  # this is a convenient way to define classs methods when
  # you have to define many class methods
  class << self
    def released
      where("released_on <= ?", Time.now).order(released_on: :desc)
    end

    def hits
      where('total_gross >= 300000000').order(total_gross: :desc)
    end

    def flops
      where('total_gross < 50000000').order(total_gross: :asc)
    end

    def recently_added
      order(created_at: :desc).limit(3)
    end
  end

  # INSTANCE METHODS
  def flop?
    total_gross.blank? || total_gross < 50000000
  end

  def new?
    id.nil?
  end

end
