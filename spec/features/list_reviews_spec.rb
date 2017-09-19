require 'rails_helper'

describe "Viewing a list of a Movie's reviews" do

  it "will display the reviews for that movie" do
    movie = Movie.create(movie_attributes)
    review1 = movie.reviews.create(review_attributes)
    review2 = movie.reviews.create(review_attributes(name: "Jeff"))

    movie2 = Movie.create(movie_attributes(title: "Superman"))
    review3 = movie2.reviews.create(review_attributes(name: "Peter Travers"))

    visit movie_reviews_url(movie)

    expect(page).to have_text(review1.name)
    expect(page).to have_text(review2.name)
    expect(page).not_to have_text(review3.name)
  end

end