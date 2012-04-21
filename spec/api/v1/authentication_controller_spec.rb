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

  describe "authorization" do
    let(:error) { { error: "Not authorized." } }

    shared_examples_for "not authenticated" do 
      it { last_response.body.should be_json_eql(error.to_json) }
      it { last_response.status.should eql(401) }
    end

    describe "without token " do
      before { get "/api/v1/users.json" }
      it_should_behave_like "not authenticated"
    end

    describe "with invalid token" do
      before { get "/api/v1/users.json", token: '' }
      it_should_behave_like "not authenticated"
    end
  end
end