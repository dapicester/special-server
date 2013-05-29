require 'spec_helper'

describe PasswordResetsController do

  let(:user) { FactoryGirl.create :user }

  before do
    visit signin_path
    click_link "password"
  end

  describe "without email" do
    it "should display an error message" do
      click_button 'Reset'
      page.should have_message :error, 'errors'
    end
  end

  describe "with invalid email" do
    it "should not send the email" do
      fill_in "Email", with: 'kajshd sad'
      click_button 'Reset'
      page.should have_message :error, 'error'
    end
  end

  describe "with email not bound to any user" do
    it "should not send the email" do
      fill_in "Email", with: 'some@email.net'
      click_button 'Reset'
      page.should have_content "Email sent"
      last_email.should be_nil # no email sent even if we say so
      page.should have_selector('title', text: 'Sign in')
    end
  end

  describe "with valid email" do
    it "should send the reset email password" do
      fill_in "Email", with: user.email
      click_button 'Reset'
      page.should have_content "Email sent"
      last_email.to.should include(user.email)
      page.should have_selector('title', text: 'Sign in')
    end

    describe "when changing the password" do
      before do
        user.password_reset_token = 'token_value'
        user.password_reset_sent_at = Time.now
        user.save
        visit edit_password_reset_path(user.password_reset_token)
      end
      it "should change the password" do
        # TODO common spec for concern
        fill_in "Password", with: "newfoobar"
        fill_in "Password confirmation", with: "newfoobar"
        click_button 'Change password'
        page.should have_message :success, 'Password has been changed.'
        page.should have_selector('title', text: 'Sign in')
      end
      describe "if the token is expired" do
        before do
          user.password_reset_sent_at = 125.minutes.ago
          user.save
        end
        it "should not change the password" do
          #TODO helpers for fill-in and click
          fill_in "Password", with: "newfoobar"
          fill_in "Password confirmation", with: "newfoobar"
          click_button 'Change password'
          page.should have_message :error, 'Your password reset request has espired.'
          page.should have_selector 'title', text: 'Reset Password'
        end
      end
    end
  end
end
