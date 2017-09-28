class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  VALID_SLUG_REGEX = /\A[a-z0-9_-]*\z/

end
