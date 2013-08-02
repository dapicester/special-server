require "spec_helper"

describe UserMailer do

  shared_examples_for "a confirmation email" do
    it "generates a multipart message" do
      mail.body.parts.length.should == 2
      mail.body.parts.collect(&:content_type).should == [
        "text/plain; charset=UTF-8",
        "text/html; charset=UTF-8"
      ]
    end
    it "renders the headers" do
      mail.subject.should eq(subject)
      mail.to.should eq([user.email])
      mail.from.should eq([ UserMailer.default[:from] ])
    end
    it "contains the token link" do
      mail.text_part.body.encoded.should match(link)
      mail.html_part.body.encoded.should match(link)
      link.should match(I18n.locale.to_s)
    end
  end

  describe "password_reset" do
    let(:user) { FactoryGirl.create(:user, password_reset_token: 'anything') }
    let(:mail) { UserMailer.password_reset(user) }
    it_behaves_like "a confirmation email" do
      let(:subject) { t('user_mailer.password_reset.subject') }
      let(:link) { edit_password_reset_path(user.password_reset_token) }
    end
  end

  describe "activation" do
    let(:user) { FactoryGirl.create(:user, activation_token: 'anything') }
    let(:mail) { UserMailer.activation(user) }
    it_behaves_like "a confirmation email" do
      let(:subject) { t('user_mailer.activation.subject') }
      let(:link) { activation_path user.activation_token, locale: I18n.locale }
    end
  end
end
