require 'rails_helper'

describe "Reviews access, a user" do

  before do
    @movie = Movie.create!(movie_attributes)
    @user = User.create!(user_attributes)
    @review = @movie.reviews.new(review_attributes)
    @review.user = @user
    @review.save
  end

  context "when not signed in" do
    it "cannot access new review page" do
      get new_movie_review_path(@movie)
      expect(response).to redirect_to(signin_url)
    end

    it "cannot create a review" do
      expect {
        create_review
      }.not_to change(Review, :count)
      expect(response).to redirect_to(signin_url)
    end

    it "cannot access edit review page" do
      get edit_movie_review_path(@movie, @review)
      expect(response).to redirect_to(signin_url)
    end

    it "cannot update a review" do
      expect {
        update_review(@review, comment: "MovieFooBoar")
      }.not_to change(@review, :comment)
      expect(response).to redirect_to(signin_url)
    end

    it "cannot delete a review" do
      expect {
        delete movie_review_path(@movie, @review)
      }.not_to change(Review, :count)
      expect(response).to redirect_to(signin_url)
    end
  end

  context "when signed in" do
    before do
      sign_in(@user, spec_type: :request)
    end

    it "can access new review page" do
      get new_movie_review_path(@movie)
      expect(response).to have_http_status(:success)
    end

    it "can create a review" do
      expect {
        create_review
      }.to change(Review, :count).by(1)
    end

    it "can access edit review page" do
      get edit_movie_review_path(@movie, @review)
      expect(response).to have_http_status(:success)
    end

    it "can update a review" do
      expect {
        update_review(@review, comment: "MovieFooBoar")
      }.to change(@review, :comment).to("MovieFooBoar")
    end

    it "can delete a review" do
      expect {
        delete movie_review_path(@movie, @review)
      }.to change(Review, :count).by(-1)
    end

    context "is restricted from" do
      before do
        @other_user = User.create!(user_attributes(name: "Ged", username: "ged", email: "ged@rush.com"))
        @other_review = @movie.reviews.new(review_attributes)
        @other_review.user = @other_user
        @other_review.save
      end

      it "acccessing edit page of another user's review" do
        get edit_movie_review_path(@movie, @other_review)
        expect(response).to redirect_to(root_url)
      end

      it "updating another user's review" do
        expect {
          update_review(@other_review, comment: "MovieFooBoar")
        }.not_to change(@other_review, :comment)
        expect(response).to redirect_to(root_url)
      end

      it "deleting another user's review" do
        expect {
          delete movie_review_path(@movie, @other_review)
        }.not_to change(Review, :count)
        expect(response).to redirect_to(root_url)
      end
    end
  end

private

def create_review
  post movie_reviews_path(@movie), params: {review: review_attributes(user: @user)}
end

def update_review(review, attributes)
  patch movie_review_path(@movie, review), params: {review: attributes}
  @review.reload
end

end