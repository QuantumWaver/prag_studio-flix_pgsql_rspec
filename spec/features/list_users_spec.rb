require 'rails_helper'

describe "Viewing the list of users" do

  it "shows the users" do
    user1 = User.create!(user_attributes(name: "Geddy", email: "geddy@rush.com", username: "bassy"))
    user2 = User.create!(user_attributes(name: "Alex", email: "alex@rush.com", username: "guitary"))
    user3 = User.create!(user_attributes(name: "Neil", email: "neil@rush.com", username: "drumy"))

    sign_in(user1)
    visit users_url

    expect(page).to have_text(user1.name)
    expect(page).to have_text(user2.name)
    expect(page).to have_text(user3.name)
  end

end