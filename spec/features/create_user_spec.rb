require 'rails_helper'

describe "Creating a user" do

  it "creates the user and shows it's details" do
    visit root_url

    click_link 'Sign Up'
    expect(current_path).to eq(signup_path)

    fill_in 'Name', with: "Geddy Lee"
    fill_in 'Email', with: "ged@rush.com"
    fill_in 'Username', with: "ged"
    fill_in 'Password', with: "rushrocks"
    fill_in 'Confirm Password', with: "rushrocks"

    click_button 'Create Account'
    expect(current_path).to eq(user_path(User.last))
    expect(page).to have_text('Geddy Lee')
  end

   it "does not save the user if it's invalid" do
    visit signup_url

    fill_in 'Name', with: "Geddy Lee"
    fill_in 'Email', with: "@r.u.sh.com"
    fill_in 'Password', with: "rushrocks"
    fill_in 'Confirm Password', with: "rushrocks"

    expect {
        click_button 'Create Account'
      }.not_to change(User, :count)

      expect(current_path).to eq(users_path)
      expect(page).to have_text('error')
   end

end