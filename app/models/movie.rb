class Movie < ApplicationRecord
  # This declaration tells Rails to expect a 'movie_id'
  # foreign key column in the table wrapped by the Review model
  has_many :reviews, dependent: :destroy
  has_attached_file :image, styles: {
    small: "90x133>",
    thumb: "50x50>",
    large: "182x268>"
  } # the > option tells ImageMagick to proportionally reduce the size of the image.

  RATINGS = %w(G PG PG-13 R NC-17)

  validates :title, :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :rating, inclusion: { in: RATINGS }
  validates_attachment :image,
    :content_type => { :content_type => ['image/jpeg', 'image/png'] },
    :size => { :less_than => 1.megabyte }

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
  def recent_reviews(num)
    reviews.order(updated_at: :desc).limit(num)
  end

  def flop?
    return true if total_gross.blank?

    if total_gross < 50000000
      return true unless reviews.count >= 50 && average_stars >= 4.0
    end

    return false
  end

  def new?
    id.nil?
  end

  def has_image?
    image.exists?
  end

  def average_stars
    reviews.average(:stars)
  end

  def unreviewed?
    reviews.count.zero?
  end

end
