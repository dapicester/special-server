require "spec_helper"

describe UserMailer do
  describe "password_reset" do
    let(:user) { FactoryGirl.create(:user, password_reset_token: 'anything') }
    let(:mail) { UserMailer.password_reset(user) }

    it "renders the headers" do
      mail.subject.should eq t('user_mailer.password_reset.subject')
      mail.to.should eq([user.email])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match(t 'user_mailer.password_reset.body.link')
      mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
      mail.body.encoded.should match(t 'user_mailer.password_reset.body.ignore')
    end
  end

end
