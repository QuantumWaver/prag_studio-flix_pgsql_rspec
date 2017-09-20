require 'rails_helper'

describe "Deleting a review" do

  it "deletes the review and redirects movie show page if no more reviews" do

    movie = Movie.create(movie_attributes)
    review1 = movie.reviews.create(review_attributes(name: "Jake"))
    review2 = movie.reviews.create(review_attributes(name: "Kevin"))

    visit movie_reviews_path(movie)

    expect {
      first(:link, 'Delete').click
    }.to change(movie.reviews, :count).by(-1)

    expect(current_path).to eq(movie_reviews_path(movie))

    first(:link, 'Delete').click
    expect(movie.reviews.count).to be_zero

    expect(current_path).to eq(movie_path(movie))
  end

end
