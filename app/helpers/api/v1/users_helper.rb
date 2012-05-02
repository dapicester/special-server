module Api::V1::UsersHelper
  
  def api_user(user)
    { id: user.id, email: user.email, name: user.name }
  end

  def api_user_list(users)
    users.map! { |u| api_user(u) }
  end

end
