module UsersHelper

  def format_form_button(user)
    user.new_record? ? 'Create Account' : 'Update Account'
  end

  def profile_image_for(user)
    url = "https://secure.gravatar.com/avatar/#{user.gravatar_id}"
    image_tag(url, alt: user.name)
  end

end
