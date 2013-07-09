if Rails.env.development?
  EmailPreview.register 'password_reset' do
    user = User.create name: 'Foo', email: 'foo@example.com'
    user.password_reset_token = 'token'
    UserMailer.password_reset(user)
  end
  EmailPreview.register 'activation' do
    user = User.create name: 'Foo', email: 'foo@example.com'
    user.activation_token = 'token'
    UserMailer.activation(user)
  end
end
