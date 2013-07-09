class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.active.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_back_or root_path
    else
      flash.now[:error] = I18n.t('sessions.create.invalid_combination')
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
