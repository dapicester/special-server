def full_title(page_title)
  base_title = "Special Social Network"
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
  cookies[:remember_token] = user.remember_token
end

RSpec::Matchers.define :have_message do |type, message = nil|
  match do |page|
    case type
    when :error 
      page.should have_selector('div.flash.error', text: message)
    when :message
      page.should have_selector('div.flash.message', text: message)
    else 
      page.should have_selector('div.flash', text: message)
    end
  end
end

