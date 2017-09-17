require 'rails_helper'

describe "Deleting a movie" do

  it "deletes the movie and redirects to index" do
    movie = Movie.create(movie_attributes)

    visit movie_url(movie)

    click_link 'Delete'

    expect(Movie.find_by(title: movie.title)).to be_nil
    expect(current_path).to eq(movies_path)
    expect(page).not_to have_text(movie.title)
  end

end

