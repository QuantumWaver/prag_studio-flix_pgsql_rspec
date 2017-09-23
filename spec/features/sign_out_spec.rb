require 'rails_helper'

describe "Signing out" do

  it "removes the user id from the session" do
    user = User.create!(user_attributes)

    sign_in(user)

    click_link 'Sign Out'

    expect(page).not_to have_link('Sign Out')
  end

end