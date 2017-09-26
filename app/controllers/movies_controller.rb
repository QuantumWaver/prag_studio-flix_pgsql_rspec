class MoviesController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]

  def index
    @movies = Movie.released
    @genres = Genre.list_by_name
  end

  def show
    @movie = Movie.find_by(id: params[:id])
    @review = @movie.reviews.new
    @fans = @movie.fans
    @genres = @movie.genres.list_by_name
    @current_favorite = current_user.find_favorite(@movie) if current_user
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      # redirect and set the flash message
      redirect_to @movie, notice: "Movie successfully created!"
    else
      # by rendering, and not redirecting, we preserve all
      # the valid data that was entered
      render :new  # 'movies/new'
    end
  end

  def update
    @movie = Movie.find(params[:id])
    if @movie.update(movie_params)
      # redirect and set the flash message
      redirect_to @movie, notice: "Movie successfully updated!"
     else
      # by rendering, and not redirecting, we preserve all
      # the valid data that was entered
      render :edit  # 'movies/edit'
    end
  end

  def destroy
    movie = Movie.find(params[:id])
    movie.destroy
    redirect_to movies_url, alert: "Movie successfully deleted!"
  end

  private

  def movie_params
    # this will throw an exception if ':movie' param is not present
    params.require(:movie).
      permit( :title,
              :description,
              :rating,
              :released_on,
              :total_gross,
              :cast,
              :director,
              :duration,
              :image,
              genre_ids: [] )

    # this will return an empty hash if the ':movie' param is not present
    #params.fetch(:movie, {}).
    #  permit(:title, :description, :rating, :released_on, :total_gross)
  end

end
