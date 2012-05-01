class Api::V1::RelationshipsController < Api::V1::BaseController
  before_filter :check_params, only: :create
  before_filter :new_followed, only: :create
  before_filter :get_followed, only: :destroy
  before_filter :correct_user, only: :destroy

  def create
    @current_user.follow!(@user)
    respond_with @user
  end

  def destroy
    @current_user.unfollow! @user
    #respond_with @user, status: :ok
    render json: @user, status: :ok
  end

private

  def check_params
    @relationship = params[:relationship]
    if @relationship.nil? || @relationship[:followed_id].nil?
      error = { error: I18n.t('unprocessable') }
      respond_with error, status: :unprocessable_entity, location: nil
    end
  end

  def new_followed
    @user = User.find(@relationship[:followed_id])
  rescue ActiveRecord::RecordNotFound
    error = { error: I18n.t('not_found', name: I18n.t('user')) }
    respond_with error, status: :not_found, location: nil
  end

  def get_followed
    @relationship = Relationship.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    error = { error: I18n.t('not_found', name: I18n.t('relationship')) }
    #respond_with error, status: :not_found, location: nil
    render json: error, status: :not_found
  end

  def correct_user
    unless @current_user == @relationship.follower
      error = { error: I18n.t('forbidden') }
      render json: error, status: :forbidden
    end
    @user = @relationship.followed
  end
end
