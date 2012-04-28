class UsersController < ApplicationController
  before_filter :signed_in_user,         
                only: [:index, :edit, :update, :following, :followers]
  before_filter :correct_user,           only: [:edit, :update]
  before_filter :already_signed_in_user, only: [:new, :create] 
  before_filter :admin_user,             only: :destroy
  before_filter :self_delete,            only: :destroy
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = I18n.t('users.create.success')
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = I18n.t('users.update.success')
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = I18n.t('users.destroy.success')
    redirect_to users_path
  end

  def following
    @title = I18n.t('users.following.title')
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = I18n.t('users.followers.title')
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def already_signed_in_user
    redirect_to(root_path) if signed_in?
  end

  def self_delete
    user = User.find(params[:id])
    redirect_to(root_path) if current_user?(user)
  end

end
