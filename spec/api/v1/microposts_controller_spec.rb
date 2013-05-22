require 'spec_helper'

describe Api::V1::MicropostsController , type: :api do
  let(:user)  { Factory(:user) }
  let(:token) { user.remember_token }

  describe "#create" do
    let(:url) { "/api/v1/microposts" }

    it "should create a new micropost" do
      expect do
        post "#{url}.json", token: token, micropost: { content: "Lorem ipsum" } 
      end.to change(user.microposts, :count).by(1) 
      response.status.should eql(201)
      micropost = user.microposts.first.to_json
      response.body.should be_json_eql(micropost)
    end

    it "should not create a new micropost" do
      expect do
        post "#{url}.json", token: token, micropost: {} 
      end.not_to change(Micropost, :count)
      response.status.should eql(422)
      error = { content: [I18n.t('errors.messages.blank')] }
      response.body.should eql(error.to_json)
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
      end.to change(user.microposts, :count).by(-1)
      response.status.should eql(200)
      response.body.should be_json_eql(micropost.to_json)
    end

    it "should not delete a non-existing micropost" do
      expect do
        url = "/api/v1/microposts/0"
        delete "#{url}.json", token: token 
      end.not_to change(Micropost, :count)
      response.status.should eql(404)
      error = { error: I18n.t('not_found', name: I18n.t('micropost')) }
      response.body.should be_json_eql(error.to_json)
    end

    it "should not delete if not owner" do
      other_micropost    # memoized
      expect do
        url = "/api/v1/microposts/#{other_micropost.id}"
        delete "#{url}.json", token: token
      end.not_to change(Micropost, :count)
      response.status.should eql(403)
      error = { error: I18n.t('forbidden') }
      response.body.should be_json_eql(error.to_json)
    end
  end
end
