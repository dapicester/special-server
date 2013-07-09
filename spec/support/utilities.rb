def full_title(page_title)
  base_title = t('appname')
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def sign_in(user)
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  # sign in when not using capybara as well
  cookies[:remember_token] = user.remember_token if user.active?
end

include ActionView::Helpers::TextHelper
def plural(count, word)
  pluralize(count, word)
end

def t(key, options={})
  I18n.translate key, options
end
