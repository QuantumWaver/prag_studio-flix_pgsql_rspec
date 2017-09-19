require 'rails_helper'

describe "Creating a Review" do

  before do
    @movie = Movie.create(movie_attributes)
  end

  it "creates the review with the review's details" do
    visit movie_path(@movie)

    click_link 'Write Review'

    expect(current_path).to eq(new_movie_review_path(@movie))

    expect(find_field('Name').value).to be_nil

    fill_in 'Name', with: "Kevin Moore"
    select "1", :from => "review_stars"
    fill_in "Location", with: "Iowa City, IA"
    fill_in "Comment", with: "I hated this movie!"

    click_button 'Post Review'
    expect(current_path).to eq(movie_reviews_path(@movie))
    expect(page).to have_text('I hated this movie!')
  end

  it "does not save the review if it's invalid" do
    visit new_movie_review_path(@movie)

    fill_in 'Name', with: "Kevin Moore"

    expect {
      click_button 'Post Review'
    }.not_to change(Review, :count)

    expect(current_path).to eq(movie_reviews_path(@movie))
    expect(page).to have_text('error')
  end

end