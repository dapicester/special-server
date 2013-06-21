source 'http://ruby.taobao.org'
#source 'http://gems.gzruby.org'
#source :rubygems

ruby '2.0.0'

gem 'rails', '3.2.13'
gem 'haml-rails', '0.4'
gem 'bootstrap-sass', '2.3.0.1'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.1.2'
gem 'will_paginate', '3.0.4'
gem 'bootstrap-will_paginate', '0.0.9'

gem 'jquery-rails', '2.2.1'
gem 'turbolinks', '1.0.0'
gem 'jquery-turbolinks', '1.0.0'
gem 'jbuilder', '1.0.1'

group :development do
  gem 'sqlite3','1.3.7'
  gem 'annotate', '2.5.0'
  gem 'rails-erd', '1.1.0'
  gem 'email_preview', '1.5.3'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '3.2.6'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '2.1.1'
end

group :development, :test do
  gem 'rspec-rails','2.13.1'
  #gem 'jasmine', git: "git://github.com/pivotal/jasmine-gem.git"
  #gem 'jasmine-headless-webkit', '0.8.4'
  gem 'json_spec', '1.0.0'
  gem 'guard-rspec', '2.5.0'
  gem 'guard-jasmine-headless-webkit'
  gem 'guard-spork', '1.5.0'
  gem 'spork-rails', github: 'railstutorial/spork-rails'
  #gem 'debugger', '1.6.0' # has issues with Ruby 2.0
  gem 'byebug', '1.4.1'
end

group :test do
  gem 'capybara', '1.1.2'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'database_cleaner', '~> 0.7.2'
  gem 'simplecov', require: false
end

# Hack to make heroky not install special groups
def hg(g)
  (ENV['HOME'].gsub('/','') == 'app' ? 'test' : g)
end

# Gems used only on Linux.
group hg(:linux) do
  gem 'rb-inotify', '0.9.0'
  gem 'libnotify', '0.8.0'
end

# Gems used only on Mac OS.
group hg(:mac) do
  gem 'rb-fsevent', '~> 0.9'
  gem 'growl', '1.0.3'
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
gem 'will-paginate-i18n', '0.1.1'
gem 'rails-i18n', '0.6.3'
