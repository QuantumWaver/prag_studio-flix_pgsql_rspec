module UsersHelper

  def format_form_button(user)
    user.new_record? ? 'Create Account' : 'Update Account'
  end

  def profile_image_for(user, options={})
    size = options[:size] || 80
    url = "https://secure.gravatar.com/avatar/#{user.gravatar_id}?s=#{size}"
    image_tag(url, alt: user.username)
  end

  def password_required?(user)
    true if user.new_record?
  end

  def listed_name(user)
    user.admin? ? "#{user.name} (#{user.username}) - admin" : "#{user.name} (#{user.username})"
  end

end
