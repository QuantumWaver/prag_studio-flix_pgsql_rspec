require 'rails_helper'

describe "Movie access:" do

  before do
    @movie = Movie.create!(movie_attributes)
  end

  context "a non-admin a user" do
    before do
      @user = User.create!(user_attributes)
      sign_in(@user, spec_type: :request)
    end

    it "cannot access new movie page" do
      get new_movie_path
      expect(response).to redirect_to(root_url)
    end

    it "cannot create a movie" do
      expect {
        create_movie
      }.not_to change(Movie, :count)
      expect(response).to redirect_to(root_url)
    end

    it "cannot access movie edit page" do
      get edit_movie_path(@movie)
      expect(response).to redirect_to(root_url)
    end

    it "cannot update a movie" do
      expect {
        update_movie(new_title: "FooBar")
      }.not_to change(@movie, :title)
      expect(response).to redirect_to(root_url)
    end

    it "cannot delete a movie" do
      expect {
        delete movie_path(@movie)
      }.not_to change(Movie, :count)
      expect(response).to redirect_to(root_url)
    end
  end

  context "a signed in Admin" do
    before do
      @admin = User.create!(user_attributes(admin: true))
    end

    it "can access new movie page" do
      get new_movie_path
      expect(response).to redirect_to(signin_url)

      sign_in(@admin, spec_type: :request)
      get new_movie_path
      expect(response).to have_http_status(:success)
    end

    it "can create a movie" do
      expect {
        create_movie
      }.not_to change(Movie, :count)
      expect(response).to redirect_to(signin_url)

      sign_in(@admin, spec_type: :request)
      expect {
        create_movie
      }.to change(Movie, :count).by(1)
    end

    it "can access movie edit page" do
      get edit_movie_path(@movie)
      expect(response).to redirect_to(signin_url)

      sign_in(@admin, spec_type: :request)
      get edit_movie_path(@movie)
      expect(response).to have_http_status(:success)
    end

    it "can update a movie" do
      expect {
        update_movie(new_title: "FooBar")
      }.not_to change(@movie, :title)
      expect(response).to redirect_to(signin_url)

      sign_in(@admin, spec_type: :request)
      expect {
        update_movie(new_title: "FooBar")
      }.to change(@movie, :title).to("FooBar")
    end

    it "can delete a movie" do
      expect {
        delete movie_path(@movie)
      }.not_to change(Movie, :count)
      expect(response).to redirect_to(signin_url)

      sign_in(@admin, spec_type: :request)
      expect {
        delete movie_path(@movie)
      }.to change(Movie, :count).by(-1)
    end
  end

private
  def create_movie
    post movies_path, params: {movie: movie_attributes(title: "Foobar", image: nil)}
  end

  def update_movie(new_title:)
    patch movie_path(@movie), params: {movie: {title: new_title} }
    @movie.reload
  end

end