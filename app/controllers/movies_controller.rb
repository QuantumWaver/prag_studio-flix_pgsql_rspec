class MoviesController < ApplicationController

  def index
    @movies = Movie.released
  end

  def show
    @movie = Movie.find_by(id: params[:id])
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
      redirect_to @movie
    end
  end

  def update
    @movie = Movie.find(params[:id])
    @movie.update(movie_params)
    redirect_to @movie
  end

  def destroy
    movie = Movie.find(params[:id])
    movie.destroy
    redirect_to movies_url
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
              :image_file_name )

    # this will return an empty hash if the ':movie' param is not present
    #params.fetch(:movie, {}).
    #  permit(:title, :description, :rating, :released_on, :total_gross)
  end

end
