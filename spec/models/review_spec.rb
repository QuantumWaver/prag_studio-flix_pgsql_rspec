require 'rails_helper'

describe "A Review" do

  it "belongs to a movie" do
    movie = Movie.create(movie_attributes)
    review = movie.reviews.new(review_attributes)
    expect(review.movie).to eq(movie)
  end

  it "with example attributes is valid" do
    movie = Movie.create(movie_attributes)
    review = Review.new(review_attributes)
    review.movie = movie
    expect(review.valid?).to eq(true)
  end

  it "requires a name" do
    review = Review.new(name: "")
    review.valid? # populates errors
    expect(review.errors[:name].any?).to eq(true)
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

end