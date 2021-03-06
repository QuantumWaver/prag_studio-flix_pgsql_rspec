class User < ApplicationRecord
  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9_\.]*\z/

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

  has_secure_password

  validates :name, presence: true
  validates :email, email: {strict_mode: true},
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true,
                       length: { minimum: 6 },
                       allow_nil: true
  validates :username, presence: true,
                       length: { minimum: 3, maximum: 50 },
                       format: { with: VALID_USERNAME_REGEX },
                       uniqueness: { case_sensitive: false }
  validates :slug, presence: true,
      uniqueness: { case_sensitive: false },
      format: { with: VALID_SLUG_REGEX }

  before_save :downcase_email
  before_save :downcase_username
  before_validation :set_slug!, on: :create

  scope :by_name, -> { order(:name) }
  scope :non_admins, -> { by_name.where(admin: false) }
  scope :admins, -> { by_name.where(admin: true) }

  class << self
    def authenticate(login, password)
      user = User.find_by(email: login.downcase) || User.find_by(username: login.downcase)
      user && user.authenticate(password)
    end
  end

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  def find_favorite(movie)
    # can do it this way because we have an index on user_id and movie_id
    Favorite.find_by(user_id: self.id, movie_id: movie.id)
    #favorites.find_by(movie_id: movie.id)
  end

  def set_slug!
    self.slug ||= username.parameterize if username.present?
  end

  # We are overriding this method as this is the method that Rails
  # calls when you use 'user_path(@user)', which normally would
  # return 'users/3', so this method would normally insert the
  # movie id into the path parameter, now we are going to put in
  # the username:
  def to_param
    slug
  end

  private

  def downcase_email
    email.downcase!
  end

  def downcase_username
    username.downcase!
  end

end
