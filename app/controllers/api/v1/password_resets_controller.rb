class Api::V1::PasswordResetsController < ActionController::Base
  respond_to :json
  before_filter :get_user, only: :update
  before_filter :token_expired, only: :update

  def create
    @form = PasswordReset.new params[:email]
    if @form.valid?
      user = User.find_by_email @form.email
      user.send_password_reset unless user.nil?
      # always send confirmation so nobody can exploit this function and found existing emails
      message = { message: t('email_sent', email: user.email) }
      respond_with message, location: nil, status: :ok
    else
      error = { error: t('bad_request') }
      respond_with error, location:nil, status: :bad_request
    end
  end

  def update
    if @user.update_attributes get_params
      #respond_with @user, status: :ok
      render json: @user, status: :ok
    else
      error = { error: t('unprocessable') }
      #respond_with error, location: nil, status: :unprocessable_entity
      render json: error, status: :unprocessable_entity
    end
  end

private

  def get_user
    @user = User.find_by_password_reset_token! params[:id]
  rescue ActiveRecord::RecordNotFound
    error = { error: t('unprocessable') }
    #respond_with error, location: nil, status: :unprocessable_entity
    render json: error, status: :unprocessable_entity
  end

  def token_expired
    if @user.password_reset_sent_at < 2.hours.ago
      error = { error: t('request_expired') }
      #respond_with error, location: nil, status: :unprocessable_entity
      render json: error, status: :unprocessable_entity
    end
  end

  def get_params
    { password: params[:password],
      password_confirmation: params[:password_confirmation] }
  end

end
