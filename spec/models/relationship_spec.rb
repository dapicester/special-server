# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Relationship do
  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:relationship) do
    follower.relationships.build(followed_id: followed.id)
  end

  subject { relationship }

  it { should be_valid }

  describe "follower methods" do
    before { relationship.save }
    before { FactoryGirl.create(:micropost, user: followed) }

    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    its(:follower) { should == follower }
    its(:followed) { should == followed }

    it "destroys relationship" do
      expect do
        followed.destroy
      end.to change(Micropost.from_users_followed_by(follower), :count).by(-1)
    end
  end

  describe "when followed id is not present" do
    before { relationship.followed_id = nil }
    it { should_not be_valid }
  end

  describe "when follower id is not present" do
    before { relationship.follower_id = nil }
    it { should_not be_valid }
  end
end
