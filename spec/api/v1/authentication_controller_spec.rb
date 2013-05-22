require 'spec_helper'

describe "API authentication", type: :api do
  describe "signin" do
    let(:user) { Factory(:user) }
    let(:url) { "/api/v1/signin" }

    it "with invalid information" do
      post "#{url}.json"
      error = { error: I18n.t('authentication_error') }
      response.body.should eql(error.to_json)
      response.status.should eql(401)
    end

    it "with valid information" do
      post "#{url}.json", email: user.email,
                          password: user.password
      token = { token: user.remember_token }
      response.body.should eql(token.to_json)
      response.status.should eql(200)
    end
  end

  describe "authorization" do
    let(:error) { { error: I18n.t('not_authorized') } }

    shared_examples_for "not authorized" do 
      it { response.body.should be_json_eql(error.to_json) }
      it { response.status.should eql(401) }
    end

    describe "without token " do
      before { get "/api/v1/users.json" }
      it_should_behave_like "not authorized"
    end

    describe "with invalid token" do
      before { get "/api/v1/users.json", token: '' }
      it_should_behave_like "not authorized"
    end
  end
end
