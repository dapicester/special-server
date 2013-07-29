class Api::V1::UsersController < Api::V1::BaseController
  include Api::V1::UsersHelper, Api::V1::MicropostsHelper

  before_filter :find_user, only: [:show, :following, :followers, :microposts]

  #TODO: https://github.com/fabrik42/acts_as_api

  def index
    users = User.page(page) 
    respond_with api_user_list(users)
  end

  def show
    respond_with api_user(@user)
  end

  def following
    followed_users = @user.followed_users.page(page)
    respond_with api_user_list(followed_users)
  end

  def followers
    followers = @user.followers.page(page)
    respond_with api_user_list(followers)
  end

  def microposts
    microposts = @user.microposts.page(page)
    respond_with microposts
  end

  def feed
    feeds = Micropost.from_users_followed_by(@current_user).page(page)
    respond_with api_feed_list(feeds)
  end

private

  def find_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    error = { error: I18n.t('not_found', name: I18n.t('user')) }
    respond_with error, status: :not_found
  end

end
