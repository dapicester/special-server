def full_title(page_title)
  base_title = t('appname')
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def sign_in(user, login = :email )
  visit signin_path
  fill_in t('sessions.new.login'),    with: login == :nick ? user.nick : user.email
  fill_in t('sessions.new.password'), with: user.password
  click_button t('sessions.new.button')
  # sign in when not using capybara as well
  cookies[:remember_token] = user.remember_token if user.active?
end

def get_cookie(name)
  Capybara.current_session.driver.request.cookies.[](name)
end

include ActionView::Helpers::TextHelper
def plural(count, word)
  pluralize(count, word)
end

def t(key, options={})
  I18n.translate key, options
end
