require 'rails_helper'

describe "Viewing an individual movie" do

  it "shows the movie's details" do
    movie = Movie.create(movie_attributes)

    visit movie_url(movie)

    expect(page).to have_text(movie.title)
    expect(page).to have_text(movie.rating)
    expect(page).to have_text(movie.description)
    expect(page).to have_text(movie.released_on)
  end

  it "shows the gross if greater than $50M" do
    movie = Movie.create(movie_attributes(total_gross: 51000000.00))

    visit movie_url(movie)
    expect(page).to have_text("$51,000,000.00")
  end

  it "shows 'Flop' if gross is < $50M" do
    movie = Movie.create(movie_attributes(total_gross: 49000000.00))

    visit movie_url(movie)
    expect(page).to have_text("Flop")
  end

end