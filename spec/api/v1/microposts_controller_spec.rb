require 'spec_helper'

describe Api::V1::MicropostsController , type: :api do
  let(:user)  { FactoryGirl.create(:user) }
  let(:token) { user.remember_token }

  describe "#create" do
    let(:url) { "/api/v1/microposts" }

    it "creates a new micropost" do
      expect do
        post "#{url}.json", token: token, micropost: { content: "Lorem ipsum" }
      end.to change(user.microposts, :count).by(1)
      response.status.should eql(201)
      micropost = user.microposts.first.to_json
      response.body.should be_json_eql(micropost)
    end

    it "does not create a new micropost" do
      expect do
        post "#{url}.json", token: token, micropost: {}
      end.not_to change(Micropost, :count)
      response.status.should eql(422)
      error = { content: [t('errors.messages.blank')] }
      response.body.should eql(error.to_json)
    end
  end

  describe "#destroy" do
    let(:micropost) { FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum") }
    let(:other_user) { FactoryGirl.create(:user) }
    let(:other_micropost) { FactoryGirl.create(:micropost, user: other_user, content: "Lorem ipsum") }

    it "deletes a micropost" do
      url = "/api/v1/microposts/#{micropost.id}"
      expect do
        delete "#{url}.json", token: token
      end.to change(user.microposts, :count).by(-1)
      response.status.should eql(200)
      response.body.should be_json_eql(micropost.to_json)
    end

    it "does not delete a non-existing micropost" do
      expect do
        url = "/api/v1/microposts/0"
        delete "#{url}.json", token: token
      end.not_to change(Micropost, :count)
      response.status.should eql(404)
      error = { error: t('not_found', name: t('micropost')) }
      response.body.should be_json_eql(error.to_json)
    end

    it "does not delete if not owner" do
      other_micropost    # memoized
      expect do
        url = "/api/v1/microposts/#{other_micropost.id}"
        delete "#{url}.json", token: token
      end.not_to change(Micropost, :count)
      response.status.should eql(403)
      error = { error: t('forbidden') }
      response.body.should be_json_eql(error.to_json)
    end
  end
end
