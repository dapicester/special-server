def api_user(user)
  { id: user.id, email: user.email, name: user.name }
end

def api_users(users)
  users.map! { |u| api_user(u) }
end

def api_feed(micropost)
  hash = {}
  user = micropost.user
  hash.merge! micropost.attributes.to_options
  hash[:user_name] =  user.name
  hash[:user_email] = user.email
  hash
end

def api_feeds(microposts)
  microposts.map! { |m| api_feed(m) }
end
