
def sign_in(user)
  visit signin_url
  fill_in "Login", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign In"
end

def sign_out
  visit root_url
  click_button "Sign Out"
end