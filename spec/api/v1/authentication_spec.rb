require 'spec_helper'

describe "API errors", type: :api do
  it "request with no token" do
    get "/api/v1/users.json", token: ""
    error = { error: "Token is invalid." }
    last_response.body.should eql(error.to_json)
  end
end
