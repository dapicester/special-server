class Api::V1::AuthenticationController < ActionController::Base
  respond_to :json

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      token = { token: user.remember_token }
      respond_with token, location: nil, status: :ok 
    else
      error = { error: I18n.t('authentication_error') } 
      respond_with error, location: nil, status: :unauthorized
    end
  end
end
