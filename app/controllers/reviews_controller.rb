class ReviewsController < ApplicationController

  before_action :set_movie

  def index
    @reviews = @movie.reviews.order(updated_at: :desc)
  end

  def new
    @review = @movie.reviews.new
  end

  def create
    @review = @movie.reviews.build(review_params)
    if @review.save
      redirect_to movie_reviews_path(@movie),
          notice: "Review successfully posted!"
    else
      render :new
    end
  end

  def edit
    @review = @movie.reviews.find(params[:id])
  end

  def update
    @review = @movie.reviews.find(params[:id])
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
    review = @movie.reviews.find(params[:id])
    review.destroy
    if @movie.reviews.count == 0
      redirect_to @movie, alert: "Review successfully deleted!"
    else
      redirect_to movie_reviews_path(@movie), alert: "Review successfully deleted!"
    end
  end

  private

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def review_params
     # this will throw an exception if ':review' param is not present
    params.require(:review).
      permit( :name,
              :stars,
              :location,
              :comment )
  end

end
