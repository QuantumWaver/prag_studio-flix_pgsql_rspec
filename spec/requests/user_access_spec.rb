require 'rails_helper'

describe "User access" do

  before do
    @user = User.create!(user_attributes)
  end

  context "when not signed in" do
    it "cannot access index" do
      get users_path
      expect(response).to redirect_to(signin_url)
    end

    it "cannot access show" do
      get user_path(@user)
      expect(response).to redirect_to(signin_url)
    end

    it "cannot access edit" do
      get edit_user_path(@user)
      expect(response).to redirect_to(signin_url)
    end

    it "cannot access update" do
      expect {
        patch user_path(@user), params: {user: {name: "FooBar"} }
        @user.reload
      }.not_to change(@user, :name)
      expect(response).to redirect_to(signin_url)
    end

    it "cannot access destroy" do
      expect {
        delete user_path(@user)
      }.not_to change(User, :count)
      expect(response).to redirect_to(signin_url)
    end
  end

  context "when signed in" do
    before do
      @user2 = User.create!(user_attributes(name: "Geddy", username: "ged", email: "ged@rush.com"))
      sign_in(@user, spec_type: :request)
    end

    it "cannot access other user's edit page" do
      get edit_user_path(@user2)
      expect(response).to redirect_to(root_url)
    end

    it "cannot update other user" do
      expect {
        patch user_path(@user2), params: {user: {name: "FooBar"} }
        @user2.reload
      }.not_to change(@user2, :name)
      expect(response).to redirect_to(root_url)
    end

    it "cannot destroy other user" do
      expect {
        delete user_path(@user2)
      }.not_to change(User, :count)
      expect(response).to redirect_to(root_url)
    end

    it "only admin can delete account" do
      @admin = User.create!(user_attributes(name: "Alex", username: "alex", email: "alex@rush.com", admin: true))

      sign_in(@user, spec_type: :request)
      expect {
        delete user_path(@user)
      }.not_to change(User, :count)
      expect(response).to redirect_to(root_url)

      sign_out(spec_type: :request)
      sign_in(@admin, spec_type: :request)
      expect {
        delete user_path(@user)
      }.to change(User, :count).by(-1)
    end
  end

end
