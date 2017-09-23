class User < ApplicationRecord
  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9_\.]*\z/

  has_secure_password

  before_save :downcase_email
  before_save :downcase_username

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

  class << self
    def authenticate(login, password)
      user = User.find_by(email: login.downcase) || User.find_by(username: login.downcase)
      user && user.authenticate(password)
    end
  end

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  private

  def downcase_email
    email.downcase!
  end

  def downcase_username
    username.downcase!
  end

end
