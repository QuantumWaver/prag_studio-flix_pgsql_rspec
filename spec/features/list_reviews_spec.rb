require 'rails_helper'

describe "Viewing a list of a Movie's reviews" do

  it "will display the reviews for that movie" do
    user = User.create!(user_attributes)
    sign_in(user)

    movie = Movie.create(movie_attributes)
    review1 = movie.reviews.create(review_attributes(user: user))
    review2 = movie.reviews.create(review_attributes(user: user, comment: "Comment 2"))

    movie2 = Movie.create(movie_attributes(title: "Superman"))
    review3 = movie2.reviews.create(review_attributes(user: user, comment: "Comment 3"))

    visit movie_reviews_url(movie)

    expect(page).to have_text(review1.comment)
    expect(page).to have_text(review2.comment)
    expect(page).not_to have_text(review3.comment)
  end

end