class UsersController < ApplicationController

  before_action :set_user, except: [:index, :new, :create]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
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
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to root_url, alert: "User account successfully deleted!"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).
      permit(:name, :email, :username, :password, :password_confirmation)
  end

end
