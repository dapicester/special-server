class Api::V1::UsersController < Api::V1::BaseController
  USER_NOT_FOUND = "User not found."

  #TODO: https://github.com/fabrik42/acts_as_api
  
  def index
    users = User.paginate(page: get_page) 
    respond_with api_users(users)
  end

  def show
    user = User.find(params[:id])
    respond_with api_user(user)
  rescue ActiveRecord::RecordNotFound
    bad_request USER_NOT_FOUND 
  end

  def following
    user = User.find(params[:id])
    followed_users = user.followed_users.paginate(page: get_page)
    respond_with api_users(followed_users)
  rescue ActiveRecord::RecordNotFound
    bad_request USER_NOT_FOUND
  end

  def followers
    user = User.find(params[:id])
    followers = user.followers.paginate(page: get_page)
    respond_with api_users(followers)
  rescue ActiveRecord::RecordNotFound
    bad_request USER_NOT_FOUND
  end

private
 
  def get_page
    params[:page] || 1
  end

  def bad_request(message)
    error = { error: message.to_s }
    respond_with(error, status: 400, location: nil)
  end

  def api_user(user)
    { id: user.id, email: user.email, name: user.name }
  end

  def api_users(users)
    users.map! { |u| api_user(u) }
  end
end
