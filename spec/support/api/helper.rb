module Helper
  include Rack::Test::Methods

  def app
    Rails.application
  end
end

RSpec.configure do |c|
  c.include Helper, type: :api
end

#JsonSpec.configure do 
  #exclude_keys "created_at", "updated_at"
#end
