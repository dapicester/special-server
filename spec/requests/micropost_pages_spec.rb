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

  describe "search" do
    before do
      create_index Micropost
      FactoryGirl.create_list(:micropost, 20, user: user, content: Faker::Lorem.sentences)
      @target_micropost = FactoryGirl.create(:micropost, user: user, content: "Hello World!")
      refresh_index Micropost
    end

    before { visit search_microposts_path }

    describe "by content" do
      before do
        fill_in 'query', with: 'hello'
        click_button t('microposts.search.button')
      end
      it { should have_selector('li', text: @target_micropost.content) }
    end

    describe "with no match" do
      before do
        fill_in 'query', with: 'difficult to find'
        click_button t('microposts.search.button')
      end
      it { should have_message(:message, t('microposts.search.not_found')) }
    end
  end
end
