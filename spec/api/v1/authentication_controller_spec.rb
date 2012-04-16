require 'spec_helper'

describe "API authentication", type: :api do
  describe "signin" do
    let(:user) { Factory(:user) }
    let(:url) { "/api/v1/signin" }

    it "with invalid information" do
      post "#{url}.json"
      error = { error: "Invalid email/password combination." }
      last_response.body.should eql(error.to_json)
      last_response.status.should eql(401)
    end

    it "with valid information" do
      post "#{url}.json", email: user.email,
                          password: user.password
      last_response.body.should eql(user.remember_token.to_json)
      last_response.status.should eql(200)
    end
  end

  describe "errors" do
    it "request with no token" do
      get "/api/v1/users.json", token: ""
      error = { error: "Token is invalid." }
      last_response.body.should eql(error.to_json)
    end
  end
end
