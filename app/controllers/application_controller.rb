class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # include all methods for sessions
  include SessionsHelper

end
