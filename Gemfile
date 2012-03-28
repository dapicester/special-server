source 'http://gems.gzruby.org'

gem 'rails', '3.2.2'
gem 'bootstrap-sass', '2.0.1'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.0.1'
gem 'will_paginate', '3.0.3'
gem 'bootstrap-will_paginate', '0.0.6'

#gem 'json'

group :development do
  gem 'sqlite3','1.3.5'
  gem 'annotate', '~> 2.4.1.beta'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '3.2.4'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.2.3'
end

gem 'jquery-rails', '2.0.1'

group :development, :test do
  gem 'rspec-rails','2.8.1'
  gem 'jasmine', git: "git://github.com/pivotal/jasmine-gem.git"
  gem 'jasmine-headless-webkit', '0.8.4'
  gem 'guard-rspec', '0.6.0'
  gem 'guard-jasmine-headless-webkit'
  gem 'guard-spork', '0.5.2'
  gem 'spork-rails', '3.2.0'
end

group :test do 
  gem 'capybara', '1.1.2'
  gem 'factory_girl_rails', '1.6.0'

  # Mac OS X
  #gem 'rb-fsevent', '0.4.3.1', :require => false
  #gem 'growl', '1.0.3'
  
  # Linux
  gem 'rb-inotify', '0.8.8'
  gem 'libnotify', '0.7.2'
  
  # Windows
  #gem 'rb-fchange'
  #gem 'rb-notifu'
  #gem 'win32console'
end

group :production do
  gem 'pg'
end

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Using Thin instead WEBrick
gem 'thin', '1.3.1'
