require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup" do
    before { visit signup_path }

    it { should have_selector('h1', text: t('users.new.title')) }
    it { should have_selector('title', text: full_title(t('users.new.title'))) }

    describe "with invalid information" do
      # empty form

      it "does not create a user" do
        expect { click_button t('users.new.button') }.not_to change(User, :count)
      end

      describe "error messages" do
        before { click_button t('users.new.button') }
        it { should have_selector('title', text: t('users.new.title')) }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in t('users.fields.name'),         with: "Example User"
        fill_in t('users.fields.email'),        with: "user@example.com"
        fill_in t('users.fields.nick'),         with: "user"
        fill_in t('users.fields.password'),     with: "foobar"
        fill_in t('users.fields.confirmation'), with: "foobar"
      end

      it "creates a user" do
        expect { click_button t('users.new.button') }.to change(User, :count).by(1)
      end

      describe "should send the activation email" do
        before { click_button t('users.new.button') }
        let (:user) { User.find_by_email('user@example.com') }

        it { user.active.should be_false }
        it { user.activation_token.should_not be_nil }
        it { last_email.to.should include(user.email) }

        it { should have_selector('title', text: t('static_pages.home.title')) }
        it { should have_message(:success, t('users.create.success', email: user.email)) }
        it { should_not have_link(t('layouts.header.signout')) }

        describe "and go to signin upon activation" do
          before { visit activation_url(id: user.activation_token) }

          specify { user.reload.active.should be_true }
          specify { user.reload.activation_token.should be_nil }
          specify { user.reload.activation_sent_at.should be_nil }

          it { should_not have_selector('title', text: user.name) }
          it { should have_message(:success, t('activations.success')) }
          it { should_not have_link(t('layouts.header.signout')) }
        end
      end
    end
  end

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: t('users.index.title')) }
    it { should have_button(t('users.index.search')) }

    describe "pagination" do
      before(:all) { FactoryGirl.create_list(:user, 30) }
      after(:all)  { User.delete_all }

      let(:first_page)  { User.page(1) }
      let(:second_page) { User.page(2) }

      it { should have_link("Next") }
      it { should have_link('2') }

      it "lists each user" do
        User.all[0..2].each do |user|
          should have_selector('li', text: user.name)
          should have_selector('li .nick', text: user.nick)
        end
      end

      it "lists the first page of users" do
        first_page.each do |user|
          should have_selector('li', text: user.name)
          should have_selector('li .nick', text: user.nick)
        end
      end

      it "does not list the second page of users" do
        second_page.each do |user|
          should_not have_selector('li', text: user.name)
          should_not have_selector('li .nick', text: user.nick)
        end
      end

      it { should_not have_link(t('users.delete.button')) }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it "has delete buttons" do
          should have_link(t('users.delete.button'), href: user_path(User.first))
        end
        it "is able to delete another user" do
          expect { click_link(t('users.delete.button')) }.to change(User, :count).by(-1)
        end
        it { should_not have_link(t('users.delete.button'), href: user_path(admin)) }
      end
    end
  end

  describe "search" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit users_path
    end

    context "for user" do
      before do
        create_index User
        FactoryGirl.create_list(:user, 15)
        @target_user = FactoryGirl.create(:user, name: 'Find me',
                                                 nick: 'whoami',
                                                 email: 'somebody@tolove.me')
        refresh_index User
      end

      shared_examples_for "find user" do
        before { click_button t('users.index.search') }
        it "finds the user" do
          should have_selector('li', text: @target_user.name)
          should have_selector('li .nick', text: @target_user.nick)
        end
      end

      describe "by name" do
        before { fill_in 'query', with: "name:#{@target_user.name}" }
        it_behaves_like "find user"
      end

      describe "by nick" do
        before { fill_in 'query', with: "nick:#{@target_user.nick}" }
        it_behaves_like "find user"
      end

      describe "by email" do
        before { fill_in 'query', with: "email:#{@target_user.email}" }
        it_behaves_like "find user"
      end

      describe "with no match" do
        before do
          fill_in 'query', with: "you_cannot_find_me"
          click_button t('users.index.search')
        end
        it { should have_message(:message, t('users.search.not_found')) }
      end

      describe "with invalid query" do
        before do
          fill_in 'query', with: "no["
          click_button t('users.index.search')
        end
        it { should_not have_message(:error) }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    before { visit user_path(user) }

    it { should have_selector('h1', text: user.name) }
    it { should have_selector('span.nick', text: user.nick) }
    it { should have_selector('title', text: user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end

    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in(user) }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "increments the followed count" do
          expect do
            click_button t('users.follow.button')
          end.to change(user.followed_users, :count).by(1)
        end

        it "increments the other user's followers count" do
          expect do
            click_button t('users.follow.button')
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button t('users.follow.button') }
          it { should have_selector('input', value: t('users.unfollow.button')) }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "decrements the followed user count" do
          expect do
            click_button t('users.unfollow.button')
          end.to change(user.followed_users, :count).by(-1)
        end

        it "decrements the other user's followers count" do
          expect do
            click_button t('users.unfollow.button')
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button t('users.unfollow.button') }
          it { should have_selector('input', value: t('users.follow.button')) }
        end
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1', text: t('users.edit.title')) }
      it { should have_selector('title', text: t('users.edit.title')) }
      it { should have_link(t('users.edit.change_avatar'), href: 'http://gravatar.com/emails', target: "_blank") }
    end

    describe "with invalid information" do
      before { click_button t('users.edit.button') }

      it { should have_content(t('shared.error_messages.errors', count: 1)) }
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      let(:new_name) { "New name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in t('users.fields.name'),         with: new_name
        fill_in t('users.fields.email'),        with: new_email
        fill_in t('users.fields.password'),     with: user.password
        fill_in t('users.fields.confirmation'), with: user.password
        click_button t('users.edit.button')
      end

      it { should have_selector('title', text: new_name) }
      it { should have_message(:success) }
      it { should have_link(t('layouts.header.signout'), href: signout_path) }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        sign_in(user)
        visit following_user_path(user)
      end

      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_in(other_user)
        visit followers_user_path(other_user)
      end

      it { should have_link(user.name, href: user_path(user)) }
    end
  end
end
