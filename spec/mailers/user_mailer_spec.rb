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

    describe "renders the body" do
      it "generates a multipart message" do
        mail.body.parts.length.should == 2
        mail.body.parts.collect(&:content_type).should == [
          "text/plain; charset=UTF-8",
          "text/html; charset=UTF-8"
        ]
      end
      describe "contains the reset password link" do
        it { mail.text_part.body.encoded.should match(edit_password_reset_path(user.password_reset_token)) }
        it { mail.html_part.body.encoded.should match(edit_password_reset_path(user.password_reset_token)) }
      end
    end
  end

end
