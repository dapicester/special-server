require 'spec_helper'


describe '/api/v1/password_resets', type: :api do
  let(:user) { FactoryGirl.create(:user) }

  describe "create" do
    let(:url) { "/api/v1/password_resets" }
    describe "ok" do
      before { post "#{url}.json", email: user.email }
      it { response.status.should eql(200) }
    end
    describe "bad request" do
      before { post "#{url}.json", email: "invalid" }
      it { response.status.should eql(400) }
      it { response.body.should eq({ error: t('bad_request') }.to_json) }
    end
  end

  describe "update" do
    before do
      user.password_reset_token = 'token_value'
      user.password_reset_sent_at = Time.now
      user.save
    end
    let(:url) { "/api/v1/password_resets/#{user.password_reset_token}" }
    describe "ok" do
      before { put "#{url}.json", password: "foobar", password_confirmation: "foobar" }
      it { response.status.should eql(200) }
    end
    describe "bad request" do
      before { put "#{url}.json", password: "foobar", password_confirmation: "" }
      it { response.status.should eql(422) }
      it { response.body.should eq({ error: t('unprocessable') }.to_json) }
    end
  end

end
