class Api::V1::UsersController < Api::V1::BaseController
  USER_NOT_FOUND = "User not found."

  #TODO: https://github.com/fabrik42/acts_as_api
  
  def index
    users = User.paginate(page: get_page) 
    respond_with api_users(users)
  end

  def show
    user = find_user
    respond_with api_user(user)
  rescue ActiveRecord::RecordNotFound
    bad_request USER_NOT_FOUND, 404 
  end

  def following
    user = find_user
    followed_users = user.followed_users.paginate(page: get_page)
    respond_with api_users(followed_users)
  rescue ActiveRecord::RecordNotFound
    bad_request USER_NOT_FOUND, 404
  end

  def followers
    user = find_user
    followers = user.followers.paginate(page: get_page)
    respond_with api_users(followers)
  rescue ActiveRecord::RecordNotFound
    bad_request USER_NOT_FOUND, 404
  end

  def microposts
    user = find_user
    microposts = user.microposts.paginate(page: get_page)
    respond_with microposts
  rescue ActiveRecord::RecordNotFound
    bad_request USER_NOT_FOUND, 404
  end

  def feed
    feeds = Micropost.from_users_followed_by(@current_user).paginate(page: get_page)
    respond_with api_feeds(feeds)
  end

private
 
  def get_page
    params[:page] || 1
  end

  def find_user
    User.find(params[:id])
  end

  def bad_request(message, code)
    error = { error: message.to_s }
    respond_with(error, status: code, location: nil)
  end

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

end
