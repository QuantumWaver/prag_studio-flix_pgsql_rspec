require 'rails_helper'

describe "Genres access," do
  before do
    @genre = Genre.create!(name: "Genre 1")
  end

  context "a user who is not an admin" do
    before do
      @user = User.create!(user_attributes)
      sign_in(@user, spec_type: :request)
    end

    it "cannot create a genre" do
      expect {
        post genres_path, params: {genre: {name: "New Genre"}}
      }.not_to change(Genre, :count)
    end

    it "cannot access genre's new page" do
      get new_genre_path
      expect(response).not_to have_http_status(:success)
    end

    it "cannot access genre's edit page" do
      get edit_genre_path(@genre)
      expect(response).not_to have_http_status(:success)
    end

    it "cannot update a genre" do
      expect {
        patch genre_path(@genre), params: {genre: {name: "Updated Genre"}}
        @genre.reload
      }.not_to change(@genre, :name)
    end

    it "cannot delete a review" do
      expect {
        delete genre_path(@genre)
      }.not_to change(Genre, :count)
    end
  end

  context "an admin must be signed in to" do
    before do
      @admin = User.create!(user_attributes(admin: true))
    end

    it "create a genre" do
      expect {
        post genres_path, params: {genre: {name: "New Genre"}}
      }.not_to change(Genre, :count)
      expect(response).to redirect_to(signin_url)
    end

    it "access genre's new page" do
      get new_genre_path
      expect(response).to redirect_to(signin_url)
    end

    it "access genre's edit page" do
      get edit_genre_path(@genre)
      expect(response).to redirect_to(signin_url)
    end

    it "update a genre" do
      expect {
        patch genre_path(@genre), params: {genre: {name: "Updated Genre"}}
        @genre.reload
      }.not_to change(@genre, :name)
      expect(response).to redirect_to(signin_url)
    end

    it "delete a review" do
      expect {
        delete genre_path(@genre)
      }.not_to change(Genre, :count)
      expect(response).to redirect_to(signin_url)
    end
  end

end