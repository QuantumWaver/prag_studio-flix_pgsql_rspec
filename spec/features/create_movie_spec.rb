require 'rails_helper'

describe "Creating a movie" do

  before do
    @genre1 = Genre.create!(name: "Genre 1")
    @genre2 = Genre.create!(name: "Genre 2")
    @genre3 = Genre.create!(name: "Genre 3")
    @admin = User.create!(user_attributes(admin: true))
    sign_in(@admin)
  end

  it "creates the movie and shows the movie's details" do
    visit movies_url

    click_link 'Add New Movie'

    expect(current_path).to eq(new_movie_path)

    expect(find_field('Title').value).to be_nil

    fill_in 'Title', with: "Created Movie Title"
    select "PG-13", :from => "movie_rating"
    fill_in "Total gross", with: "75000000"

    fill_in "Cast", with: "The award-winning cast"
    fill_in "Director", with: "The ever-creative director"
    fill_in "Duration", with: "123 min"
    fill_in "Description", with: "desc" * 24
    attach_file "Image", "#{Rails.root}/app/assets/images/ironman.jpg"
    check(@genre1.name)
    check(@genre2.name)

    click_button 'Create Movie'
    expect(current_path).to eq(movie_path(Movie.last))
    expect(page).to have_text('Created Movie Title')
    expect(page).to have_text(@genre1.name)
    expect(page).to have_text(@genre2.name)
    expect(page).not_to have_text(@genre3.name)
  end

    it "does not save the movie if it's invalid" do
      visit new_movie_url

      expect {
        click_button 'Create Movie'
      }.not_to change(Movie, :count)

      expect(current_path).to eq(movies_path)
      expect(page).to have_text('error')
    end

end