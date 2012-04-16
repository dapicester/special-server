class Api::V1::AuthenticationController < ActionController::Base
  respond_to :json

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      token = user.remember_token.to_json
      respond_with(token, status: 200, location: nil)
    else
      error = { error: "Invalid email/password combination." } 
      respond_with(error, status: 401, location: nil)
    end
  end
end
