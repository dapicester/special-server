class Api::V1::UsersController < Api::V1::BaseController
  def index
    page = params[:page] || 1
    respond_with User.paginate(page: page)
  end
end
