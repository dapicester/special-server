require 'spec_helper'

describe "/api/v1/users", type: :api do
  let(:user) { Factory(:user) }
  let(:token) { user.remember_token }

  describe "index" do
    let(:url) { "/api/v1/users" }

    before(:all) { 30.times { Factory(:user) } }
    after(:all)  { User.delete_all }

    let(:first_page)  { User.paginate(page: 1) }
    let(:second_page) { User.paginate(page: 2) }

    describe "default pagination" do
      before { get "#{url}.json", token: token }

      it { last_response.body.should eql(first_page.to_json) }
      it { last_response.status.should eql(200) }
    end

    describe "explicit pagination" do
      before { get "#{url}.json", token: token, page: 2 }

      it { last_response.body.should eql(second_page.to_json) }
      it { last_response.status.should eql(200) }
   end
  end

  describe "following/followers" do
    let(:other_user) { Factory(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before { get "/api/v1/users/#{user.id}/following.json", token: token }

      it { last_response.body.should eql([other_user].to_json) }
      it { last_response.status.should eql(200) }
    end

    describe "followers" do
      before { get "/api/v1/users/#{other_user.id}/followers.json", token: token }

      it { last_response.body.should eql([user].to_json) }
      it { last_response.status.should eql(200) }
    end

    describe "bad request" do
      before { get "/api/v1/users/0/following.json", token: token }

      it { last_response.status.should eql(400) }
    end
  end
end
