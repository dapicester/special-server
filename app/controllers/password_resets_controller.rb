class PasswordResetsController < ApplicationController

  def new
    @form = PasswordReset.new
  end

  def create
    #require 'debugger'; debugger
    # FIXME perche ci vuole la doppia hash?
    @form = PasswordReset.new params[:password_reset][:email]
    if @form.valid?
      user = User.find_by_email @form.email
      user.send_password_reset unless user.nil?
      # always send confirmation so nobody can exploit this function and found existing emails
      flash[:success] = "Email sent to #{@form.email} with password reset instructions." #I18n.t('sessions.create.invalid_combination')
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
      redirect_to new_passsword_reset_path, alert: "Password &crarr; reset has espired"
    elsif @user.update_attributes params[:user]
      redirect_to root_url, notice: 'Password has been reset.'
    else
      render :edit
    end
  end

end
