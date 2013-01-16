source 'http://gems.gzruby.org'

gem 'rails', '3.2.11'
gem 'bootstrap-sass', '2.0.1'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.0.1'
gem 'will_paginate', '3.0.3'
gem 'bootstrap-will_paginate', '0.0.6'

gem 'json'
gem 'jquery-rails', '2.0.1'

group :development do
  gem 'sqlite3','1.3.5'
  gem 'annotate', '~> 2.4.1.beta'
  gem 'rails-erd', '~> 0.4.5'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '3.2.4'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.2.3'
end

group :development, :test do
  gem 'rspec-rails','2.9.0'
  #gem 'jasmine', git: "git://github.com/pivotal/jasmine-gem.git"
  #gem 'jasmine-headless-webkit', '0.8.4'
  gem 'json_spec', '1.0.0'
  gem 'guard-rspec', '0.6.0'
  gem 'guard-jasmine-headless-webkit'
  gem 'guard-spork', '0.5.2'
  gem 'spork-rails', '3.2.0'
  gem 'debugger', '1.1.1'
end

group :test do 
  gem 'capybara', '1.1.2'
  gem 'factory_girl_rails', '1.6.0'
  gem 'database_cleaner', '~> 0.7.2'
  gem 'simplecov', require: false
end

# Hack to make heroky not install special groups
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
  gem 'rb-fsevent', git: 'git://github.com/ttilley/rb-fsevent.git', branch: 'pre-compiled-gem-one-off', 
                    require: false
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
gem 'will-paginate-i18n', '0.1.1'
gem 'rails-i18n', '0.6.3'
