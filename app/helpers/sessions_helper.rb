module SessionsHelper

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    # if (user_id = session[:user_id])
    #   @current_user ||= User.find_by(id: user_id)
    # elsif (user_id = cookies.signed[:user_id])
    #   user = User.find_by(id: user_id)
    #   if user && user.authenticated?(:remember, cookies[:remember_token])
    #     log_in user
    #     @current_user = user
    #   end
    # end
  end

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    #forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

end
