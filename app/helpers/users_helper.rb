module UsersHelper

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50 })
    if Rails.env.development?
      style = "width:#{options[:size]}px;height#{options[:size]}px;border:1px solid #000;float:left;margin-right:10px"
      return image_tag '', alt: user.name, style: style
    end
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  # Return '@nickname' for the given user
  def at_nick(user)
    "@#{user.nick}"
  end

end
