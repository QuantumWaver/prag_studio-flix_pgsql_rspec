require 'rails_helper'

describe "Genres can be" do

  before do
    @genre1 = Genre.create!(name: "Genre 1")
    @genre2 = Genre.create!(name: "Genre 2")
    @genre3 = Genre.create!(name: "Genre 3")
    @admin = User.create!(user_attributes(admin: true))
    sign_in(@admin)
  end

  it "listed with links to genre show page with associated movies" do
    movie = Movie.create!(movie_attributes)
    movie.genre_ids = [@genre1.id]

    visit genres_url
    expect(page).to have_link(@genre1.name)
    expect(page).to have_link(@genre2.name)
    expect(page).to have_link(@genre3.name)

    click_link @genre1.name
    expect(current_path).to eq(genre_path(@genre1))
    expect(page).to have_text(movie.title)

    click_link movie.title
    expect(current_path).to eq(movie_path(movie))

    within("aside#sidebar") do
      expect(page).to have_text(@genre1.name)
    end
  end

  it "created by an admin" do
    visit new_genre_url
    expect(find_field('Name').value).to be_nil

    fill_in 'Name', with: "New Genre"
    expect {
      click_button 'Create Genre'
    }.to change(Genre, :count).by(1)
    expect(Genre.last.name).to eq("New Genre")
  end

  it "edited by an admin" do
    visit genre_url(@genre2)
    expect(page).to have_text(@genre2.name)

    click_link 'Edit'
    expect(current_path).to eq(edit_genre_path(@genre2))
    expect(find_field('Name').value).to eq(@genre2.name)

    fill_in 'Name', with: "Updated Genre Name"
    click_button 'Update Genre'
    expect(current_path).to eq(genre_path(@genre2))
    expect(page).to have_text("Updated Genre Name")
  end

  it "deleted by an admin" do
    visit genre_url(@genre2)
    expect(page).to have_text(@genre2.name)

    expect {
      click_link 'Delete'
    }.to change(Genre, :count).by(-1)

    expect(current_path).to eq(genres_path)
    expect(page).not_to have_link(@genre2.name)
  end
end