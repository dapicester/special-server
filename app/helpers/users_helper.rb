module UsersHelper

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    if Rails.env.development? or Rails.env.test?
      gravatar_url = "gravatar-#{size}.png"
    else
      gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
    end
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  # Return '@nickname' for the given user
  def at_nick(user)
    "@#{user.nick}"
  end

end
