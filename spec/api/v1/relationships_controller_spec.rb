require 'spec_helper'

describe Api::V1::RelationshipsController, type: :api do
  let(:user)       { Factory(:user) }
  let(:token)      { user.remember_token }
  
  let(:other_user) { Factory(:user) }

  let(:url) { "/api/v1/relationships" } 
  
  describe "#create" do
    let(:relationship) { { followed_id: other_user.id } }

    it "should create a new relationship" do
      expect do
        post "#{url}.json", token: token, relationship: relationship
      end.to change(user.followed_users, :count).by(1)
      last_response.status.should eql(201)
    end

    it "should not create a new relationship" do
      expect do
        post "#{url}.json", token: token, relationship: {}
      end.not_to change(Relationship, :count)
      last_response.status.should eql(422)
    end
  end

  describe "#destroy" do
    before do
      user.follow!(other_user)
      other_user.follow!(user)
    end

    let(:relationship)       { user.relationships.find_by_followed_id(other_user) }
    let(:other_relationship) { other_user.relationships.find_by_followed_id(user) }

    it "should delete a relationship" do
      expect do
        delete "#{url}/#{relationship.id}.json", token: token
      end.to change(user.followed_users, :count).by(-1)
      last_response.status.should eql(200)
    end

    it "should not delete a non-existent relationship" do
      expect do
        delete "#{url}/0.json", token: token
      end.not_to change(Relationship, :count)
      last_response.status.should eql(404)
    end

    it "should not delete if not owner" do
      expect do
        delete "#{url}/#{other_relationship.id}.json", token: token
      end.not_to change(Relationship, :count)
      last_response.status.should eql(403)
    end
  end
end
