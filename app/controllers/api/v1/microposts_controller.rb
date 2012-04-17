class Api::V1::MicropostsController < Api::V1::BaseController
  before_filter :find_micropost, only: :destroy
  before_filter :correct_user,   only: :destroy

  def create
    micropost = @current_user.microposts.build(params[:micropost])
    if micropost.save
      respond_with micropost, location: api_v1_micropost_path(micropost)
    else
      respond_with micropost.errors.messages, location: nil, status: :unprocessable_entity
    end
  end

  def destroy
    @micropost.destroy
    #respond_with @micropost, location: nil, status: :ok
    render json: @micropost, status: :ok
  end

private

  def find_micropost
    @micropost = Micropost.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    error = { error: "Not found. "}
    #respond_with( error, location: nil, status: :not_found )
    render json: error, status: :not_found
  end

  def correct_user
    unless @current_user == @micropost.user
      error = { error: "Forbidden." } 
      #respond_with( error, location: nil, status: :forbidden )
      render json: error, status: :forbidden
    end
  end
end
