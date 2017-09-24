class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # include all methods for sessions
  include SessionsHelper

private

  def require_signin
    unless logged_in?
      store_location
      redirect_to signin_url, alert: "Please sign in first."
    end
  end

  def require_admin
    redirect_to root_url unless current_user_admin?
  end

end
