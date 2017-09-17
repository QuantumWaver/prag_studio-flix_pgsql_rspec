require 'rails_helper'

describe "Navigating movies" do

  before do
    @movie = Movie.create(movie_attributes)
  end

  it "allows navigation from the detail page to the listing page" do
    visit movie_url(@movie)

    click_link "Back to All Movies"
    expect(current_path).to eq(movies_path)
  end

  it "allows navigation from the detail page to the edit page" do
    visit movie_url(@movie)

    click_link "Edit"
    expect(current_path).to eq(edit_movie_path(@movie))
  end

  it "allows navigation from the listing page to the detail page" do
    visit movies_url

    click_link @movie.title
    expect(current_path).to eq(movie_path(@movie))
  end

  it "allows cancelation from Edit and New pages back to the index" do
    visit new_movie_url
    click_link 'Cancel'
    expect(current_path).to eq(movies_path)

    visit edit_movie_url(@movie)
    click_link 'Cancel'
    expect(current_path).to eq(movies_path)
  end
end