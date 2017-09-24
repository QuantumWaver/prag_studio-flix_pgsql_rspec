require 'rails_helper'

describe "Deleting a User" do

  before do
    @user = User.create!(user_attributes(admin: true))
  end

  it "deletes the user, signs them out, and redirects to root" do
    sign_in(@user)
    visit user_url(@user)

    expect {
      click_link 'Delete Account'
    }.to change(User, :count).by(-1)

    expect(current_path).to eq(root_path)

    expect(page).to have_link('Sign In')
    expect(page).not_to have_link('Sign Out')

    visit users_url
    expect(page).not_to have_text(@user.name)
  end

end