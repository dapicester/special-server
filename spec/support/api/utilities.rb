def api_user(user)
  { id: user.id, email: user.email, name: user.name }
end

def api_users(users)
  users.map! { |u| api_user(u) }
end
