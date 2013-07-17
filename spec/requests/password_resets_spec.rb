require 'spec_helper'

describe PasswordResetsController do

  subject { page }

  let(:user) { FactoryGirl.create :user }

  before do
    visit signin_path
    click_link t('sessions.new.forgot')
  end

  describe "without email" do
    it "displays an error message" do
      click_button t('password_resets.new.button')
      should have_message :error
    end
  end

  describe "with invalid email" do
    it "does not send the email" do
      fill_in t('users.fields.email'), with: 'kajshd sad'
      click_button t('password_resets.new.button')
      should have_message :error
    end
  end

  describe "with email not bound to any user" do
    let(:email) { 'some@email.net' }
    it "does not send the email" do
      fill_in t('users.fields.email'), with: email
      click_button t('password_resets.new.button')
      should have_content t('password_resets.email.sent', email: email)
      should have_selector('title', text: t('sessions.new.title'))
      last_email.should be_nil # no email sent even if we say so
    end
  end

  describe "with valid email" do
    it "sends the reset email password" do
      fill_in t('users.fields.email'), with: user.email
      click_button t('password_resets.new.button')
      should have_content t('password_resets.email.sent', email: user.email)
      should have_selector('title', text: t('sessions.new.title'))
      last_email.to.should include(user.email)
      user.reload
      user.password_reset_token.should_not be_nil
      user.password_reset_sent_at.should_not be_nil
    end

    describe "when changing the password" do
      before do
        user.password_reset_token = 'token_value'
        user.password_reset_sent_at = Time.now
        user.save
        visit edit_password_reset_path(user.password_reset_token)
      end
      it "changes the password" do
        fill_in t('users.fields.password'), with: "newfoobar"
        fill_in t('users.fields.confirmation'), with: "newfoobar"
        click_button t('password_resets.edit.button')
        should have_message :success, t('password_resets.changed')
        should have_selector('title', text: t('sessions.new.title'))
        user.reload
        user.password_reset_token.should be_nil
        user.password_reset_sent_at.should be_nil
      end
      it "has error if password empty" do
        click_button t('password_resets.edit.button')
        should have_message :error
      end
      it "has error if password not valid" do
        fill_in t('users.fields.password'), with: "foobar"
        fill_in t('users.fields.confirmation'), with: "barfoo"
        click_button t('password_resets.edit.button')
        should have_message :error
      end
      describe "if the token is expired" do
        before do
          user.password_reset_sent_at = 125.minutes.ago
          user.save
        end
        it "does not change the password" do
          # TODO helpers for fill-in and click
          fill_in t('users.fields.password'), with: "newfoobar"
          fill_in t('users.fields.confirmation'), with: "newfoobar"
          click_button t('password_resets.edit.button')
          should have_message :error, t('password_resets.expired')
          should have_selector 'title', text: t('password_resets.new.title')
        end
      end
    end
  end
end
