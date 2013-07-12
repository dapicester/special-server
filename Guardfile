# A sample Guardfile
# More info at https://github.com/guard/guard#readme

require 'active_support/core_ext'

guard 'spork', cucumber_env: { 'RAILS_ENV' => 'test' },
               rspec_env:    { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb')       { :rspec }
  watch(%r{^spec/support/(.+)\.rb$}) { :rspec }
  watch('test/test_helper.rb') { :test_unit }
  watch(%r{features/support/}) { :cucumber }
end

guard 'rspec', all_after_pass: false, cli: '--drb' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch('spec/factories.rb')    { "spec" }

  # Rails
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$}) do |m|
    ["spec/routing/#{m[1]}_routing_spec.rb",
     "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
     "spec/acceptance/#{m[1]}_spec.rb",
     "spec/requests/#{m[1].singularize}_pages_spec.rb"]
  end
  watch(%r{^app/controllers/api/(v[1-9])/(.+)_(controller)\.rb$}) do |m|
    "spec/api/#{m[1]}/#{m[2]}_#{m[3]}_spec.rb"
  end
  watch(%r{^app/views/(.+)/}) do |m|
    "spec/requests/#{m[1].singularize}_pages_spec.rb"
  end
  watch(%r{^config/locales/(.*)\.yml$})               { "spec/i18n_spec.rb" }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
  # Capybara request specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}_spec.rb" }
end

# jasmine requires that phantomjs is installed.
guard :jasmine do
  watch(%r{spec/javascripts/spec\.(js\.coffee|js|coffee)$}) { 'spec/javascripts' }
  watch(%r{spec/javascripts/.+_spec\.(js\.coffee|js|coffee)$})
  watch(%r{spec/javascripts/fixtures/.+$})
  watch(%r{app/assets/javascripts/(.+?)\.(js\.coffee|js|coffee)(?:\.\w+)*$}) { |m| "spec/javascripts/#{ m[1] }_spec.#{ m[2] }" }
end
