RSpec::Matchers.define :have_message do |type, message = nil|
  match do |page|
    case type
    when :error 
      page.should have_selector('div.alert.alert-error', text: message)
    when :message
      page.should have_selector('div.alert.alert-message', text: message)
    else 
      page.should have_selector('div.alert.alert-success', text: message)
    end
  end
end
