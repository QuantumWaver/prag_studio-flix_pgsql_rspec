require 'rails_helper'

describe "Deleting a User" do

  before do
    @user = User.create!(user_attributes)
  end

  it "deletes the user and redirects to root" do
    visit user_url(@user)

    expect {
      click_link 'Delete Account'
    }.to change(User, :count).by(-1)

    expect(current_path).to eq(root_path)

    visit users_url
    expect(page).not_to have_text(@user.name)
  end

  it "automatically signs out that user" do
    sign_in(@user)

    visit user_path(@user)

    click_link 'Delete Account'

    expect(page).to have_link('Sign In')
    expect(page).not_to have_link('Sign Out')
  end

end