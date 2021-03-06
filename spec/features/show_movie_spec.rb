require 'rails_helper'

describe "Viewing an individual movie" do

  it "shows the movie's details" do
    movie = Movie.create(movie_attributes(released_on: "1977-07-15"))

    visit movie_url(movie)

    expect(page).to have_text(movie.title)
    expect(page).to have_text(movie.rating)
    expect(page).to have_text(movie.description)
    expect(page).to have_text("July 15, 1977")

    expect(page).to have_text(movie.cast)
    expect(page).to have_text(movie.director)
    expect(page).to have_text(movie.duration)
    expect(page).to have_selector("img[src$='#{movie.image.url(:large)}']")
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

  it "has an SEO-friendly URL" do
    movie = Movie.create!(movie_attributes(title: "X-Men: The Last Stand"))
    visit movie_url(movie)
    expect(current_path).to eq("/movies/x-men-the-last-stand")
  end

end