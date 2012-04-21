class Api::V1::UsersController < Api::V1::BaseController
  before_filter :find_user, only: [:show, :following, :followers, :microposts]

  #TODO: https://github.com/fabrik42/acts_as_api
  
  def index
    users = User.paginate(page: page) 
    respond_with api_users(users)
  end

  def show
    respond_with api_user(@user)
  end

  def following
    followed_users = @user.followed_users.paginate(page: page)
    respond_with api_users(followed_users)
  end

  def followers
    followers = @user.followers.paginate(page: page)
    respond_with api_users(followers)
  end

  def microposts
    microposts = @user.microposts.paginate(page: page)
    respond_with microposts
  end

  def feed
    feeds = Micropost.from_users_followed_by(@current_user).paginate(page: page)
    respond_with api_feeds(feeds)
  end

private
 
  def find_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    error = { error: "User not found." }
    respond_with(error, status: :not_found, location: nil)
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
