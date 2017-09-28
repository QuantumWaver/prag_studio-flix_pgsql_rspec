class UsersController < ApplicationController

  before_action :require_signin, except: [:new, :create]
  before_action :require_correct_user, only: [:edit, :update]
  before_action :require_admin, only: [:destroy]

  def index
    @users = User.by_name
  end

  def show
    @user = User.find_by!(slug: params[:id])
    @favorite_movies = @user.favorite_movies
    @reviews = @user.reviews
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      redirect_to @user, notice: "Thanks for signing up!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      # redirect and set the flash message
      redirect_to @user, notice: "Account successfully updated!"
     else
      # by rendering, and not redirecting, we preserve all
      # the valid data that was entered
      @user.username = User.find(@user.id).username if @user.errors[:username].any?
      render :edit
    end
  end

  def destroy
    @user = User.find_by!(slug: params[:id])
    @user.destroy
    log_out
    redirect_to root_url, alert: "User account successfully deleted!"
  end

  private

  # Confirms the correct user by checking the user given by the request in the params
  # with the current signed in user
  def require_correct_user
    @user = User.find_by!(slug: params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def user_params
    params.require(:user).
      permit(:name, :email, :username, :password, :password_confirmation)
  end

end
