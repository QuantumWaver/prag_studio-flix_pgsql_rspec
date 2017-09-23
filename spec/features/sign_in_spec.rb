require 'rails_helper'

describe "Signing in a User" do

  before do
    @user = User.create!(user_attributes)
  end

  it "returns the proper sign in form" do
    visit root_url

    click_link 'Sign In'
    expect(current_path).to eq(signin_path)

    expect(page).to have_field("Login")
    expect(page).to have_field("Password")
  end

  it "signs in user if email/password combo is valid" do
    visit signin_url

    fill_in 'Login', with: @user.email
    fill_in 'Password', with: @user.password

    click_button 'Sign In'
    expect(current_path).to eq(user_path(@user))
    expect(page).to have_link('Sign Out')
  end

  it "signs in user if username/password combo is valid" do
    visit signin_url

    fill_in 'Login', with: @user.username
    fill_in 'Password', with: @user.password

    click_button 'Sign In'
    expect(current_path).to eq(user_path(@user))
    expect(page).to have_link('Sign Out')
  end

  it "does not sign in user if email/password combo is invalid" do
    visit signin_url

    fill_in 'Login', with: @user.email
    fill_in 'Password', with: "nomatch"

    click_button 'Sign In'
    expect(current_path).to eq(session_path)
    expect(page).not_to have_link('Sign Out')
  end

end