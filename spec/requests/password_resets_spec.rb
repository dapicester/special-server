require 'spec_helper'

describe PasswordResetsController do

  let(:user) { FactoryGirl.create :user }

  before do
    visit signin_path
    click_link t('sessions.new.forgot')
  end

  describe "without email" do
    it "should display an error message" do
      click_button t('password_resets.new.button')
      page.should have_message :error, 'errors'
    end
  end

  describe "with invalid email" do
    it "should not send the email" do
      fill_in t('users.fields.email'), with: 'kajshd sad'
      click_button t('password_resets.new.button')
      page.should have_message :error, 'error'
    end
  end

  describe "with email not bound to any user" do
    let(:email) { 'some@email.net' }
    it "should not send the email" do
      fill_in "Email", with: email
      click_button t('password_resets.new.button')
      page.should have_content t('password_resets.email.sent', email: email)
      last_email.should be_nil # no email sent even if we say so
      page.should have_selector('title', text: t('sessions.new.title'))
    end
  end

  describe "with valid email" do
    it "should send the reset email password" do
      fill_in "Email", with: user.email
      click_button t('password_resets.new.button')
      page.should have_content t('password_resets.email.sent', email: user.email)
      last_email.to.should include(user.email)
      page.should have_selector('title', text: t('sessions.new.title'))
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
        click_button t('password_resets.edit.button')
        page.should have_message :success, t('password_resets.changed')
        page.should have_selector('title', text: t('sessions.new.title'))
      end
      describe "if the token is expired" do
        before do
          user.password_reset_sent_at = 125.minutes.ago
          user.save
        end
        it "should not change the password" do
          # TODO helpers for fill-in and click
          fill_in "Password", with: "newfoobar"
          fill_in "Password confirmation", with: "newfoobar"
          click_button t('password_resets.edit.button')
          page.should have_message :error, t('password_resets.expired')
          page.should have_selector 'title', text: t('password_resets.new.title')
        end
      end
    end
  end
end
