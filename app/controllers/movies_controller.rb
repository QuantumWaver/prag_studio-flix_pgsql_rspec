class MoviesController < ApplicationController
  MOVIES_INDEX_SCOPE = /hits|flops|upcoming|recent/

  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]
  before_action :set_movie, only: [:show, :edit, :update, :destroy]

  def index
    @movies = Movie.send(movie_index_scope)
    @genres = Genre.list_by_name
  end

  def show
    @review = @movie.reviews.new
    @fans = @movie.fans
    @genres = @movie.genres.list_by_name
    @current_favorite = current_user.find_favorite(@movie) if current_user
  end

  def edit
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
    if @movie.update(movie_params)
      # redirect and set the flash message
      redirect_to @movie, notice: "Movie successfully updated!"
     else
      # by rendering, and not redirecting, we preserve all
      # the valid data that was entered
      @movie.slug = Movie.find(@movie.id).slug if @movie.errors[:slug].any?
      render :edit  # 'movies/edit'
    end
  end

  def destroy
    @movie.destroy
    redirect_to movies_url, alert: "Movie successfully deleted!"
  end

  private

  def set_movie
    @movie = Movie.find_by!(slug: params[:id])
  end

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
              :slug,
              genre_ids: [] )

    # this will return an empty hash if the ':movie' param is not present
    #params.fetch(:movie, {}).
    #  permit(:title, :description, :rating, :released_on, :total_gross)
  end

  def movie_index_scope
    if params[:scope].in? %w(hits flops upcoming recent)
      params[:scope]
    else
      :released
    end
  end

end
