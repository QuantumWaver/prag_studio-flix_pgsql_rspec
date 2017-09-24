
def sign_in(user, spec_type: :feature)
  if spec_type == :feature
    visit signin_url
    fill_in "Login", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign In"
  else
    post session_path, params: { login: user.email, password: user.password }
  end
end

def sign_out(spec_type: :feature)
  if spec_type == :feature
    visit root_url
    click_button "Sign Out"
  else
    delete session_path
  end
end