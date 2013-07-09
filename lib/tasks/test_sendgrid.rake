require 'mail'

namespace :heroku do
  namespace :test do

    desc "Send a mail using the SendGrid extension"
    task :sendgrid, :recipient do |task, args|
      abort 'Must specify a recipient' unless args[:recipient]
      send_test_mail args[:recipient]
    end

  end
end

# from: https://devcenter.heroku.com/articles/sendgrid

Mail.defaults do
  delivery_method :smtp, { :address   => "smtp.sendgrid.net",
                           :port      => 587,
                           :domain    => "example.com",
                           :user_name => ENV['SENDGRID_USERNAME'],
                           :password  => ENV['SENDGRID_PASSWORD'],
                           :authentication => 'plain',
                           :enable_starttls_auto => true }
end

def send_test_mail(recipient)
  puts "sending test email to: #{recipient} ..."
  Mail.deliver do
    to 'dapicester@gmail.com'
    from 'Sendgrid <sendgrid@example.com>'
    subject 'Test email'
    text_part do
      body 'Hello world in text'
    end
    html_part do
      content_type 'text/html; charset=UTF-8'
      body '<b>Hello world in HTML</b>'
    end
  end
  puts "mail sent"
end
