class ReviewsController < ApplicationController
  before_action :require_signin, except: [:index]
  before_action :set_movie
  before_action :set_review, only: [:edit, :update, :destroy]

  def index
    @reviews = @movie.reviews.order(updated_at: :desc)
  end

  def new
    @review = @movie.reviews.new
  end

  def create
    if @review = @movie.review_by(current_user)
      redirect_to edit_movie_review_url(@movie, @review),
          alert: "You already have a review for this movie."
    else
      @review = @movie.reviews.build(review_params)
      @review.user = current_user
      if @review.save
        redirect_to movie_reviews_url(@movie),
            notice: "Review successfully posted!"
      else
        render :new
      end
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      # redirect and set the flash message
      redirect_to movie_reviews_path(@movie, @review), notice: "Review successfully updated!"
     else
      # by rendering, and not redirecting, we preserve all
      # the valid data that was entered
      render :edit
    end
  end

  def destroy
    @review.destroy
    if @movie.reviews.count == 0
      redirect_to @movie, alert: "Review successfully deleted!"
    else
      redirect_to movie_reviews_path(@movie), alert: "Review successfully deleted!"
    end
  end

  private

  def set_review
    @review = current_user.reviews.find(params[:id])
  end

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def review_params
     # this will throw an exception if ':review' param is not present
    params.require(:review).
      permit(:stars, :location, :comment)
  end

end
