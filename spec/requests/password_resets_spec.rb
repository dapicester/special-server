require 'spec_helper'

describe PasswordResetsController do

  let(:user) { FactoryGirl.create :user }

  before do
    visit signin_path
    click_link "password"
  end

  describe "with invalid password" do
    it "should not send the email" do
      fill_in "Email", with: 'some@email.net'
      click_button 'Reset'
      page.should have_content("Email sent")
      last_email.should be_nil
    end
  end

  describe "with valid password" do
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
