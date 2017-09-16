require 'rails_helper'

describe "Creating a movie" do

  it "creates the movie and shows the movie's details" do
    visit movies_url

    click_link 'Add New Movie'

    expect(current_path).to eq(new_movie_path)

    expect(find_field('Title').value).to be_nil

    fill_in 'Title', with: "Created Movie Title"
    fill_in 'Rating', with: "PG-13"
    fill_in "Total gross", with: "75000000"

    click_button 'Create Movie'
    expect(current_path).to eq(movie_path(Movie.last))
    expect(page).to have_text('Created Movie Title')
  end

end