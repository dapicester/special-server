module Api::V1::MicropostsHelper
  
  def api_feed(micropost)
    hash = {}
    user = micropost.user
    hash.merge! micropost.attributes.to_options
    hash[:user_name] =  user.name
    hash[:user_email] = user.email
    hash
  end

  def api_feed_list(microposts)
    microposts.map! { |m| api_feed(m) }
  end

end
