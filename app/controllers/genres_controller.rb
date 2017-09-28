class GenresController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]
  before_action :set_genre, except: [:index, :new, :create]

  def index
    @genres = Genre.list_by_name
  end

  def show
    @movies = @genre.movies.by_title
    @genres = Genre.list_by_name
  end

  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to @genre, notice: "Genre successfully created!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @genre.update(genre_params)
      redirect_to @genre, notice: "Genre successfully updated!"
     else
      render :edit
    end
  end

  def destroy
    @genre.destroy
    redirect_to genres_url
  end

private

  def set_genre
    @genre = Genre.find(params[:id])
  end

  def genre_params
     # this will throw an exception if ':review' param is not present
    params.require(:genre).
      permit(:name)
  end

end
