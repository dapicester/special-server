class Api::V1::UsersController < Api::V1::BaseController
  def index
    respond_with User.paginate(page: get_page)
  end

  def following
    user = User.find(params[:id])
    respond_with user.followed_users.paginate(page: get_page)
  rescue ActiveRecord::RecordNotFound
    bad_request "User not found"
  end

  def followers
    user = User.find(params[:id])
    respond_with user.followers.paginate(page: get_page)
  rescue ActiveRecord::RecordNotFound
    bad_request "User not found"
  end

private
  
  def get_page
    params[:page] || 1
  end

  def bad_request(message)
    error = { error: message.to_s }
    respond_with(error, status: 400, location: nil)
  end
end
