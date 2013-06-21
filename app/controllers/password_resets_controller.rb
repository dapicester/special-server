class PasswordResetsController < ApplicationController

  def new
    @form = PasswordReset.new
  end

  def create
    # FIXME why need double hash?
    @form = PasswordReset.new params[:password_reset][:email]
    if @form.valid?
      user = User.find_by_email @form.email
      user.send_password_reset unless user.nil?
      # always send confirmation so nobody can exploit this function and found existing emails
      flash[:success] = I18n.t('password_resets.email.sent', email: @form.email)
      redirect_to signin_path
    else
      render :new
    end
  end

  def edit
    @user = User.find_by_password_reset_token! params[:id] # 404 if not found
  end

  def update
    @user = User.find_by_password_reset_token! params[:id]
    if @user.password_reset_sent_at < 2.hours.ago
      flash[:error] = I18n.t('password_resets.expired')
      redirect_to new_password_reset_path
    elsif @user.update_attributes params[:user]
      @user.clear_password_token!
      flash[:success] = I18n.t('password_resets.changed')
      redirect_to signin_path
    else
      render :edit
    end
  end

end
