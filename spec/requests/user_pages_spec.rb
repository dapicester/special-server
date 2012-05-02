require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    let(:user) { Factory(:user) }

    before do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: t('users.index.title')) }

    describe "pagination" do
      before(:all) { 30.times { Factory(:user) } }
      after(:all)  { User.delete_all }
      
      let(:first_page)  { User.paginate(page: 1) }
      let(:second_page) { User.paginate(page: 2) }

      it { should have_link("Next") }
      it { should have_link('2') }

      it "should list each user" do
        User.all[0..2].each do |user|
          should have_selector('li', text: user.name)
        end
      end

      it "should list the first page of users" do
        first_page.each do |user|
          should have_selector('li', text: user.name)
        end
      end

      it "should not list the second page of users" do
        second_page.each do |user|
          should_not have_selector('li', text: user.name)
        end
      end

      it { should_not have_link(t('users.delete.button')) }

      describe "as an admin user" do
        let(:admin) { Factory(:admin) }
        before do 
          sign_in admin
          visit users_path
        end

        it { should have_link(t('users.delete.button'), href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link(t('users.delete.button')) }.to change(User, :count).by(-1)
        end
        it { should_not have_link(t('users.delete.button'), href: user_path(admin)) }
      end
    end
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1', text: t('users.new.title')) }
    it { should have_selector('title', text: full_title(t('users.new.title'))) }
  end

  describe "profile page" do
    let(:user) { Factory(:user) }
    let!(:m1) { Factory(:micropost, user: user, content: "Foo") }
    let!(:m2) { Factory(:micropost, user: user, content: "Bar") }

    before { visit user_path(user) }

    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end

    describe "follow/unfollow buttons" do
      let(:other_user) { Factory(:user) }
      before { sign_in(user) }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed count" do
          expect do
            click_button t('users.follow.button')
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
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

        it "should decrement the followed user count" do
          expect do
            click_button t('users.unfollow.button')
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
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

  describe "signup" do
    before { visit signup_path }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button t('users.new.button') }.not_to change(User, :count)
      end
    end

    describe "error messages" do
      before { click_button t('users.new.button') }

      it { should have_selector('title', text: t('users.new.title')) }
      it { should have_content('error') }
    end

    describe "with valid information" do
      before do
        fill_in t('users.fields.name'),         with: "Example User"
        fill_in t('users.fields.email'),        with: "user@example.com"
        fill_in t('users.fields.password'),     with: "foobar"
        fill_in t('users.fields.confirmation'), with: "foobar"
      end

      it "should create a user" do
        expect { click_button t('users.new.button') }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button t('users.new.button') }
        let (:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_message(:success, t('users.create.success')) }
        it { should have_link(t('layouts.header.signout')) }
      end
    end
  end

  describe "edit" do
    let(:user) { Factory(:user) }
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
      let(:user) { Factory(:user) }
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
    let(:user) { Factory(:user) }
    let(:other_user) { Factory(:user) }
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
