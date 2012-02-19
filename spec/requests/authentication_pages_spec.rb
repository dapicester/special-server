require 'spec_helper'

describe "Authentication" do
  
  subject { page }

  describe "signin" do
    before { visit signin_path }
   
    it { should_not have_link('Profile') }
    it { should_not have_link('Settings') }
     
    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('title', text: 'Sign in') }  
      it { should have_message(:error, 'Invalid') }
      
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_message(:error) }
      end
    end
 
    describe "with valid information" do
      let(:user) { Factory(:user) }
      before { sign_in user }

      it { should have_selector('title', text: user.name) }

      it { should have_link('Users', href: users_path) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }

      it { should_not have_link('Sign in', href: signin_path) }
       
      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
        it { should_not have_link('Profile') }
        it { should_not have_link('Settings') }
      end
    end

    describe "for signed-in users" do
      let(:user) { Factory(:user) }
      let(:another) { Factory(:user) }

      before { sign_in user }

      describe "visiting users#new page" do
        before { visit signup_path }
        it { should have_selector('title', text: 'Home') }
      end

      describe "submitting a POST request to the users#create action" do
        before { post users_path(another) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end

  describe "authorization" do
    
    describe "for non-signed-in users" do
      let(:user) { Factory(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end
          
        describe "after signing in" do
          it "should render the desired protected page" do
            should have_selector('title', text: 'Edit user')
          end

          describe "when signing in again" do
            before do 
              visit signin_path
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"
            end

            it "should render the default (profile) page" do
              should have_selector('title', text: user.name)
            end
          end
        end
      end
 
      describe "visiting user index" do
        before { visit users_path }
        it { should have_selector('title', text: 'Sign in') }
      end

      describe "in the Users controller" do 

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end
        
        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
         
      end
    end

    describe "as wrong user" do
      let(:user) { Factory(:user) }
      let(:wrong_user) { Factory(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should have_selector('title', text: 'Home') }
      end

      describe "submitting a PUT request to the users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { Factory(:user) }
      let(:non_admin) { Factory(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as admin user" do
      let(:admin) { Factory(:admin) }
    
      before { sign_in admin }
     
      describe "submitting a DELETE request for himself" do
        before { delete user_path(admin) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
end
