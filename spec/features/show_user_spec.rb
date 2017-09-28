require 'rails_helper'

describe "Showing the user" do
  before do
    @user = User.create!(user_attributes(name: "Geddy", email: "geddy@rush.com", username: "bassy_man"))
    sign_in(@user)
  end

  it "shows the user's details" do
    visit user_url(@user)

    expect(page).to have_text(@user.name)
    expect(page).to have_text(@user.email)
    expect(page).to have_text(@user.username)
  end

  it "has an SEO-friendly URL" do
    visit user_url(@user)
    expect(current_path).to eq("/users/#{@user.username}")
  end

end