require 'rails_helper'

describe "Editing a User" do

  before do
    @user = User.create!(user_attributes)
  end

  it "updates the User and shows the User's updated details" do
    visit user_url(@user)
    click_link 'Edit Account'

    expect(current_path).to eq(edit_user_path(@user))

    expect(find_field('Name').value).to eq(@user.name)
    expect(find_field('Email').value).to eq(@user.email)
    expect(find_field('Username').value).to eq(@user.username)

    fill_in 'Name', with: "Geddy Lee"
    fill_in 'Email', with: "ged@rush.com"
    fill_in 'Username', with: "bassy"

    click_button 'Update Account'
    expect(current_path).to eq(user_path(@user))
    expect(page).to have_text('Geddy Lee')
    expect(page).to have_text('ged@rush.com')
    expect(page).to have_text('bassy')
  end

  it "does not save the user if it's invalid" do
    visit edit_user_url(@user)

    fill_in 'Name', with: " "

    expect {
      click_button 'Update Account'
    }.not_to change(@user, :name)

    expect(current_path).to eq(user_path(@user))
    expect(page).to have_text('error')
  end

  it "if password present, doesn't save unless match" do
    visit edit_user_url(@user)

    fill_in 'Name', with: "Geddy Lee"
    fill_in 'Email', with: "ged@rush.com"
    fill_in 'Password', with: "rushrocks"
    fill_in 'Confirm Password', with: "rushrocks_diff"

    expect {
      click_button 'Update Account'
    }.not_to change(@user, :name)

    expect(current_path).to eq(user_path(@user))
    expect(page).to have_text('error')

    fill_in 'Password', with: "rushrocks"
    fill_in 'Confirm Password', with: "rushrocks"

    expect {
      click_button 'Update Account'
      @user.reload
    }.to change(@user, :name)

    expect(current_path).to eq(user_path(@user))
    expect(page).not_to have_text('error')
  end

end