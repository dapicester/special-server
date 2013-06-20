class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def password_reset(user)
    @user = user
    mail to: @user.email,
         subject: t('user_mailer.password_reset.subject')
  end

  def activation(user)
    @user = user
    mail to: @user.email,
         subject: t('user_mailer.activation.subject')
  end
end
