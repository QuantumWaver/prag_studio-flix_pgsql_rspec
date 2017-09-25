require 'rails_helper'

describe "A Review" do

  it "belongs to a movie" do
    movie = Movie.create(movie_attributes)
    review = movie.reviews.new(review_attributes)
    expect(review.movie).to eq(movie)
  end

  it "belongs to a user" do
    user = User.create(user_attributes)
    review = user.reviews.new(review_attributes)
    expect(review.user).to eq(user)
  end

  it "with example attributes is valid" do
    user = User.create(user_attributes)
    movie = Movie.create(movie_attributes)
    review = Review.new(review_attributes(user: user))
    review.movie = movie
    expect(review.valid?).to eq(true)
  end

  it "requires a comment" do
    review = Review.new(comment: "")
    review.valid?
    expect(review.errors[:comment].any?).to eq(true)
  end

  it "requires a comment over 3 characters" do
    review = Review.new(comment: "X" * 3)
    review.valid?
    expect(review.errors[:comment].any?).to eq(true)
  end

  it "accepts star values of 1 through 5" do
    stars = Review::STARS
    stars.each do |star|
      review = Review.new(stars: star)
      review.valid?
      expect(review.errors[:stars].any?).to eq(false)
    end
  end

  it "rejects invalid star values" do
    stars = [-1, 0, 6, "", "blah", 3.14, nil]
    stars.each do |star|
      review = Review.new(stars: star)
      review.valid?
      expect(review.errors[:stars].any?).to eq(true)
    end
  end

  it "requires a location" do
    review = Review.new(location: "")
    review.valid?
    expect(review.errors[:location].any?).to eq(true)
  end

  it "requires a location over 3 characters" do
    review = Review.new(location: "X" * 3)
    review.valid?
    expect(review.errors[:location].any?).to eq(true)
  end

end