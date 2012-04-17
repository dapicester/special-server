require 'spec_helper'

describe Api::V1::MicropostsController , type: :api do
  let(:user)  { Factory(:user) }
  let(:token) { user.remember_token }

  describe "#create" do
    let(:url) { "/api/v1/microposts" }

    it "should create a new micropost" do
      expect do
        post "#{url}.json", token: token, micropost: { content: "Lorem ipsum" } 
      end.should change(user.microposts, :count).by(1) 
      last_response.status.should eql(201)
      micropost = user.microposts.first.to_json
      last_response.body.should be_json_eql(micropost)
    end

    it "should not create a new micropost" do
      expect do
        post "#{url}.json", token: token, micropost: {} 
      end.should_not change(user.microposts, :count)
      last_response.status.should eql(422)
      last_response.body.should eql({ content: ["can't be blank"] }.to_json)
    end
  end

  describe "#destroy" do
    let(:micropost) { Factory(:micropost, user: user, content: "Lorem ipsum") }
    let(:other_user) { Factory(:user) }
    let(:other_micropost) { Factory(:micropost, user: other_user, content: "Lorem ipsum") }

    it "should delete a micropost" do
      url = "/api/v1/microposts/#{micropost.id}"
      expect do
        delete "#{url}.json", token: token 
      end.should change(user.microposts, :count).by(-1)
      last_response.status.should eql(200)
    end

    it "should not delete a non-existing micropost" do
      expect do
        url = "/api/v1/microposts/0"
        delete "#{url}.json", token: token 
      end.should_not change(user.microposts, :count)
      last_response.status.should eql(404)
    end

    it "should not delete if not owner" do
      other_micropost    # memoized
      expect do
        url = "/api/v1/microposts/#{other_micropost.id}"
        delete "#{url}.json", token: token
      end.should_not change(other_user.microposts, :count)
      last_response.status.should eql(403)
    end
  end
end
