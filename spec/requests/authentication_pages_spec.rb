require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin" do
    before { visit signin_path }

    it { should_not have_link(t('layouts.header.profile')) }
    it { should_not have_link(t('layouts.header.settings')) }

    describe "with invalid information" do
      before { click_button t('sessions.new.button') }

      it { should have_selector('title', text: t('sessions.new.title')) }
      it { should have_message(:error, 'Invalid') }

      describe "after visiting another page" do
        before { click_link t('static_pages.home.title') }
        it { should_not have_message(:error) }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user, active: false) }

      describe "but not activated" do
        before { sign_in user }

        it { should have_selector('title', text: t('sessions.new.title')) }

        it { should_not have_link(t('users.index.title'), href: users_path) }
        it { should_not have_link("#{user.email}", href: '#') }
        it { should have_link(t('layouts.header.signin'),  href: signin_path) }
      end

      describe "and user is activated" do

        shared_examples_for "signed in user" do
          it { should have_selector('title', text: t('static_pages.home.title')) }

          it { should have_link(t('users.index.title'), href: users_path) }
          it { should have_link("#{user.email}", href: '#') }
          it { should have_link(t('layouts.header.profile'),  href: user_path(user)) }
          it { should have_link(t('layouts.header.settings'), href: edit_user_path(user)) }
          it { should have_link(t('layouts.header.signout'),  href: signout_path) }

          it { should_not have_link(t('layouts.header.signin'), href: signin_path) }

          describe "followed by signout" do
            before { click_link t('layouts.header.signout') }
            it { should have_link(t('layouts.header.signin')) }
            it { should_not have_link(t('layouts.header.profile')) }
            it { should_not have_link(t('layouts.header.settings')) }
          end
        end

        describe "using email" do
          before do
            user.activate!
            sign_in user
          end
          it_behaves_like "signed in user"
        end

        describe "using nick" do
          before do
            user.activate!
            sign_in user, :nick
          end
          it_behaves_like "signed in user"
        end
      end
    end

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      let(:another) { FactoryGirl.create(:user) }

      before { sign_in user }

      describe "visiting users#new page" do
        before { visit signup_path }
        it { should have_selector('title', text: t('static_pages.home.title')) }
      end

      describe "submitting a POST request to the users#create action" do
        before { post users_path, id: another }
        specify { response.should redirect_to(root_path) }
      end
    end
  end

  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button t('sessions.new.button')
        end

        describe "after signing in" do
          it "renders the desired protected page" do
            should have_selector('title', text: t('users.edit.title'))
          end

          describe "when signing in again" do
            before do 
              visit signin_path
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button t('sessions.new.button')
            end

            it "renders the default (home) page" do
              should have_selector('title', text: t('static_pages.home.title'))
            end
          end
        end
      end

      describe "visiting user index" do
        before { visit users_path }
        it { should have_selector('title', text: t('layouts.header.signin')) }
      end

      describe "in the Users controller" do 
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: t('layouts.header.signin')) }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the following page" do 
          before { visit following_user_path(user) }
          it { should have_selector('title', text: t('layouts.header.signin')) }
        end

        describe "visiting the followers page" do
          before { visit followers_user_path(user) }
          it { should have_selector('title', text: t('layouts.header.signin')) }
        end
      end

      describe "in the Microposts controller" do
        describe "submitting to the create action" do
          before { post microposts_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before do
            micropost = FactoryGirl.create(:micropost)
            delete micropost_path(micropost)
          end
          specify { response.should redirect_to(signin_path) }
        end
      end

      describe "in the Relationships controller" do
        describe "submitting to the create action" do
          before { post relationships_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete relationship_path(1) }
          specify { response.should redirect_to(signin_path) }
        end 
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should have_selector('title', text: t('static_pages.home.title')) }
      end

      describe "submitting a PUT request to the users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as admin user" do
      let(:admin) { FactoryGirl.create(:admin) }

      before { sign_in admin }

      describe "submitting a DELETE request for himself" do
        before { delete user_path(admin) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
end
