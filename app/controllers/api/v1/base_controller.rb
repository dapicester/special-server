class Api::V1::BaseController < ActionController::Base
  respond_to :json
  before_filter :authenticate_user
  
private
  def authenticate_user
    @current_user = User.find_by_remember_token(params[:token])
    unless @current_user
      error = { error: "Not authenticated." }
      respond_with error, location: nil, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
