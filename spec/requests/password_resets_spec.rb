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
    end
  end

  describe "with valid email" do
    it "should send the reset email password" do
      fill_in "Email", with: user.email
      click_button 'Reset'
      page.should have_content "Email sent"
      last_email.to.should include(user.email)
    end
  end

  # TODO: password changes on confirmation
  # TODO: token expired
  # TODO: token invalid
end
