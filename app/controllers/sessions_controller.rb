class SessionsController < ApplicationController

  def new
  end

  def create
    if user = User.authenticate(params[:login], params[:password])
      log_in(user)
      flash.now[:notice] = "Welcome back, #{user.username}!"
      redirect_back_or_to user
    else
      flash.now[:alert] = "Invalid login/password combination!"
      render :new
    end
  end

  def destroy
    log_out # if logged_in?
    redirect_to root_url, notice: "Signed out successfully!"
  end

end
