if Rails.env.development?
  EmailPreview.register 'password_reset' do
    user = User.create name: 'Foo', email: 'foo@example.com'
    user.password_reset_token = 'token'
    UserMailer.password_reset(user)
  end
end
