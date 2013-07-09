class UserMailer < ActionMailer::Base
  default from: DEFAULT_SENDER

  def password_reset(user)
    @user = user
    mail to: email_with_name,
         subject: t('user_mailer.password_reset.subject')
  end

  def activation(user)
    @user = user
    mail to: email_with_name,
         subject: t('user_mailer.activation.subject')
  end

private

  def email_with_name
    "#{@user.name} <#{@user.email}>"
  end
end
