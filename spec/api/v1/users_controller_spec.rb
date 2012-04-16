require 'spec_helper'

describe "/api/v1/users", type: :api do
  let(:user) { Factory(:user) }
  let(:token) { user.remember_token }

  context "index" do 
    let(:url) { "/api/v1/users" }
    it "json" do
      get "#{url}.json", token: token

      users_json = User.all.to_json
      last_response.body.should eql(users_json)
      last_response.status.should eql(200)
    end
  end
end
