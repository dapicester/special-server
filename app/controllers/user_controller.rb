class UserController < ApplicationController
  def index
  end

  def register
    if request.post? and params[:user]
      @user = User.new(params[:user])
      if @user.save
        flash[:notice] = "User #{@user.screen_name} created!"
        redirect_to :action => "index"
      end
    end
  end
end
