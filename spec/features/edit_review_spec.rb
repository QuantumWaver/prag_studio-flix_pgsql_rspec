require 'rails_helper'

describe "Editing a review" do

  before do
    @movie = Movie.create(movie_attributes)
    @review = @movie.reviews.create(review_attributes)
  end

  it "updates the review and shows the movie's reviews page" do
    visit movie_reviews_path(@movie)

    first(:link, 'Edit').click

    expect(current_path).to eq(edit_movie_review_path(@movie, @review))

    expect(find_field('Name').value).to eq(@review.name)

    fill_in 'Name', with: "Updated Name"
    click_button 'Update Review'
    expect(current_path).to have_text(movie_reviews_path(@movie))
    expect(page).to have_text('Updated Name')
  end

  it "does not save the movie if it's invalid" do

    visit edit_movie_review_url(@movie, @review)

    fill_in 'Name', with: " "

    expect {
      click_button 'Update Review'
    }.not_to change(@review, :name)

    expect(current_path).to eq(movie_review_path(@movie, @review))
    expect(page).to have_text('error')
  end

end