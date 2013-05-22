source 'http://ruby.taobao.org'

ruby '2.0.0'

gem 'rails', '4.0.0.rc1'

gem 'bootstrap-sass', '2.3.0.1'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.1.2'
gem 'will_paginate', '3.0.4'
gem 'bootstrap-will_paginate', '0.0.9'

gem 'jquery-rails', '2.2.1'
gem 'turbolinks', '1.0.0'
gem 'jbuilder', '1.0.1'

group :development do
  gem 'sqlite3','1.3.7'
  #gem 'annotate', '~> 2.4.1.beta'
  #gem 'rails-erd', '~> 0.4.5'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '4.0.0.rc1'
  gem 'coffee-rails', '4.0.0'
  gem 'uglifier', '1.2.3'
end

group :development, :test do
  gem 'rspec-rails','2.13.1'
  #gem 'jasmine', gitihub: "pivotal/jasmine-gem.git"
  #gem 'jasmine-headless-webkit', '0.8.4'
  #gem 'json_spec', '1.0.0'
  gem 'guard-rspec', '2.5.0'
  #gem 'guard-jasmine-headless-webkit', '0.3.2'
  gem 'guard-spork', '1.5.0'
  gem 'childprocess', '0.3.6'
  gem 'spork-rails', github: 'railstutorial/spork-rails'
  gem 'debugger', '1.6.0'
end

group :test do
  gem 'selenium-webdriver', '2.0'
  gem 'capybara', '2.1.0.rc1'
  gem 'factory_girl_rails', '4.2.0'
  gem 'database_cleaner', github: 'bmabey/database_cleaner'
  gem 'simplecov', '0.7.1', require: false
end

# Hack to make heroku not install special groups
def hg(g)
  (ENV['HOME'].gsub('/','') == 'app' ? 'test' : g)
end

# Gems used only on Linux.
group hg(:linux) do
  gem 'rb-inotify'
  gem 'libnotify'
end

# Gems used only on Mac OS.
group hg(:mac) do
  gem 'rb-fsevent', '0.9.3', require: false
  gem 'growl'
end

# Gems used only on Windows.
#group hg(:windows) do
#  gem 'rb-fchange'
#  gem 'rb-notifu'
#  gem 'win32console'
#end

# Gems used only in production environment.
group :production do
  gem 'pg'
end

# To use debugger
# gem 'ruby-debug'

# Use Thin webserver
gem 'thin', '1.3.1'

# Deployment platform
gem 'heroku'

# I18n
gem 'will-paginate-i18n', '0.1.11'
gem 'rails-i18n', '0.6.6'
