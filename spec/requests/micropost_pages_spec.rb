require 'spec_helper'

describe "MicropostPages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do
      it "does not create a micropost" do
        expect { click_button t 'microposts.micropost.button' }.to_not change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button t 'microposts.micropost.button' }
        it { should have_content('1 error') }
      end
    end

    describe "with valid information" do
      before { fill_in 'micropost_form', with: "Lorem ipsum" }
      it "creates a micropost" do
        expect { click_button t 'microposts.micropost.button' }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "deletes a micropost" do
        expect { click_link t 'shared.delete_post.delete' }.to change(Micropost, :count).by(-1)
      end
    end
  end
end
