require 'rails_helper'

describe "Creating a Review" do

  before do
    @movie = Movie.create!(movie_attributes)
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  it "creates the review with the review's details" do
    visit new_movie_review_path(@movie)

    expect(find_field('Location').value).to be_nil

    choose'review_stars_3'
    fill_in "Location", with: "Iowa City, IA"
    fill_in "Comment", with: "I hated this movie!"

    click_button 'Post Review'
    expect(current_path).to eq(movie_path(@movie))
    expect(page).to have_text('I hated this movie!')
  end

  it "can be done directly from the Movie's show page" do
    visit movie_path(@movie)

    choose'review_stars_3'
    fill_in "Location", with: "Iowa City, IA"
    fill_in "Comment", with: "I hated this movie!"

    click_button 'Post Review'
    expect(current_path).to eq(movie_path(@movie))
    expect(page).to have_text('I hated this movie!')
  end

  it "does not save the review if it's invalid" do
    visit new_movie_review_path(@movie)

    expect {
      click_button 'Post Review'
    }.not_to change(Review, :count)

    expect(current_path).to eq(movie_reviews_path(@movie))
    expect(page).to have_text('error')
  end

end