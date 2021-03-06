class Movie < ApplicationRecord
  # This declaration tells Rails to expect a 'movie_id'
  # foreign key column in the table wrapped by the Review model
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :critics, through: :reviews, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  has_attached_file :image, styles: {
    small: "90x133>",
    thumb: "50x50>",
    large: "182x268>"
  } # the > option tells ImageMagick to proportionally reduce the size of the image.

  RATINGS = %w(G PG PG-13 R NC-17)

  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :rating, inclusion: { in: RATINGS }
  validates_attachment :image,
    :content_type => { :content_type => ['image/jpeg', 'image/png'] },
    :size => { :less_than => 1.megabyte }
  validates :slug, presence: true,
      uniqueness: { case_sensitive: false },
      format: { with: VALID_SLUG_REGEX }

  before_validation :set_slug!, on: :create

  scope :released, -> { where("released_on <= ?", Time.now).order(released_on: :desc) }
  scope :hits, -> { released.where('total_gross >= 300000000').order(total_gross: :desc) }
  scope :flops, -> { released.where('total_gross < 50000000').order(total_gross: :asc) }
  scope :recently_added, ->(max = 3) { order(created_at: :desc).limit(max) }
  scope :upcoming, -> { where("released_on > ?", Time.now).order(released_on: :asc) }
  scope :rated, ->(rating) { where(rating: rating).order(:title) }
  scope :recent, ->(max=5) { released.limit(max) }
  scope :by_title, -> { order(title: :asc) }

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

  def released?
    released_on <= Time.now
  end

  def has_image?
    image.exists?
  end

  def has_fan?(user)
    fans.include?(user)
  end

  def review_by(user)
    reviews.find_by(user_id: user.id)
  end

  def reviewed_by?(user)
    critics.include?(user)
  end

  def average_stars
    reviews.average(:stars)
  end

  def unreviewed?
    reviews.count.zero?
  end

  def set_slug!
    self.slug ||= title.parameterize if title.present?
  end

  # We are overriding this method as this is the method that Rails
  # calls when you use 'movie_path(@movie)', which normally would
  # return 'movies/3', so this method would normally insert the
  # movie id into the path parameter, now we are going to put in
  # the slug:
  def to_param
    slug
  end

end
