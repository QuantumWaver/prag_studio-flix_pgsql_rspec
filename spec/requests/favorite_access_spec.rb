require 'rails_helper'

describe "Favorites access, a user" do

  before do
    @movie = Movie.create!(movie_attributes)
    @user = User.create!(user_attributes)
  end

  context "when not signed in" do
    it "cannot fav a movie" do
      expect {
        post movie_favorites_path(@movie)
      }.not_to change(Favorite, :count)
      expect(response).to redirect_to(signin_url)
    end

    it "cannot unfav a movie" do
      fav = @movie.favorites.create!(user: @user)
      expect {
        delete movie_favorite_path(@movie, fav)
      }.not_to change(Favorite, :count)
      expect(response).to redirect_to(signin_url)
    end
  end

  context "when signed in" do
    before do
      sign_in(@user, spec_type: :request)
    end

    it "can fav a movie" do
      expect {
        post movie_favorites_path(@movie)
      }.to change(Favorite, :count).by(1)
    end

    it "can unfav a movie" do
      fav = @movie.favorites.create!(user: @user)
      expect {
        delete movie_favorite_path(@movie, fav)
      }.to change(Favorite, :count).by(-1)
    end

    it "cannot fav a movie more than once" do
      @movie.favorites.create!(user: @user)
      expect {
        post movie_favorites_path(@movie)
      }.not_to change(Favorite, :count)
    end

    it "cannot delete another user's fav" do
      other_user = User.create!(user_attributes(name: "Ged", username: "ged", email: "ged@rush.com"))
      other_user_fav = @movie.favorites.create!(user: other_user)
      expect {
        expect{
          delete movie_favorite_path(@movie, other_user_fav)
        }.to raise_exception(ActiveRecord::RecordNotFound)
      }.not_to change(Favorite, :count)
    end
  end

end