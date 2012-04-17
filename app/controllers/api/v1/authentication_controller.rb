class Api::V1::AuthenticationController < ActionController::Base
  respond_to :json

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      token = user.remember_token.to_json
      respond_with token, location: nil, status: :ok 
    else
      error = { error: "Invalid email/password combination." } 
      respond_with error, location: nil, status: :unauthorized
    end
  end
end
