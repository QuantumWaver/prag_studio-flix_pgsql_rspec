require 'rails_helper'

describe "Showing the user" do

  it "shows the user's details" do
    user = User.create!(user_attributes(name: "Geddy", email: "geddy@rush.com", username: "bassy"))

    visit user_url(user)

    expect(page).to have_text(user.name)
    expect(page).to have_text(user.email)
    expect(page).to have_text(user.username)
  end

end