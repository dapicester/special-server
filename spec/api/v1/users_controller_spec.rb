require 'spec_helper'

describe "/api/v1/users", type: :api do
  let(:user) { Factory(:user) }
  let(:token) { user.remember_token }

  describe "index" do
    let(:url) { "/api/v1/users" }

    before(:all) { 30.times { Factory(:user) } }
    after(:all)  { User.delete_all }

    let(:first_page)  { api_users User.paginate(page: 1) }
    let(:second_page) { api_users User.paginate(page: 2) }

    describe "default pagination" do
      before { get "#{url}.json", token: token }

      it { last_response.body.should be_json_eql(first_page.to_json) }
      it { last_response.status.should eql(200) }
    end

    describe "explicit pagination" do
      before { get "#{url}.json", token: token, page: 2 }

      it { last_response.body.should be_json_eql(second_page.to_json) }
      it { last_response.status.should eql(200) }
   end
  end

  describe "show" do
    let(:url) { "/api/v1/users/#{user.id}" }

    describe "should not show private data" do
      before { get "#{url}.json", token: token }
    
      it { last_response.body.should be_json_eql(api_user(user).to_json) }
      it { last_response.status.should eql(200) }
    end
  end

  describe "following/followers" do
    let(:other_user) { Factory(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before { get "/api/v1/users/#{user.id}/following.json", token: token }

      it { last_response.body.should be_json_eql(api_users([ other_user ]).to_json) }
      it { last_response.status.should eql(200) }
    end

    describe "followers" do
      before { get "/api/v1/users/#{other_user.id}/followers.json", token: token }

      it { last_response.body.should be_json_eql(api_users([ user ]).to_json) }
      it { last_response.status.should eql(200) }
    end
  end

  shared_examples_for "user not found" do
    it { last_response.status.should eql(404) }
    it { last_response.body.should eq({ error: "User not found." }.to_json) }
  end

  describe "bad requests" do
    describe "show" do
      before { get "/api/v1/users/0.json", token: token }
      it_should_behave_like "user not found"
    end

    describe "following" do
      before { get "/api/v1/users/0/following.json", token: token }
      it_should_behave_like "user not found"
    end

    describe "followers" do
      before { get "/api/v1/users/0/followers.json", token: token }
      it_should_behave_like "user not found"
    end
  end
end
