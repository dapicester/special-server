# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  password_digest        :string(255)
#  remember_token         :string(255)
#  admin                  :boolean          default(FALSE)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  activation_token       :string(255)
#  activation_sent_at     :datetime
#  active                 :boolean          default(FALSE)
#  nick                   :string(255)      not null
#

require 'spec_helper'

describe User do

  before do
    @user = User.new(
      name: "Example user",
      nick: "example",
      email: "user@example.com",
      password: "foobar",
      password_confirmation: "foobar"
    )
  end

  subject { @user }

  it { should be_valid }
  it { should_not be_active }
  it { should_not be_admin }

  shared_examples_for "respond to" do |values|
    values.each do |val|
    end
  end

  describe "responds to" do
    %i[ name
        nick
        email
        password_digest
        password
        password_confirmation
        remember_token
        admin
        microposts
        relationships
        followed_users
        reverse_relationships
        followers

        authenticate
        send_password_reset
        password_reset_token
        password_reset_sent_at
        send_activation
        activation_token
        activation_sent_at
        active?
        activate!
        feed
        following?
        follow!
        unfollow!
      ].each do |sym|
        it { should respond_to(sym) }
      end
  end

  describe "with admin attribute set to 'true'" do
    before { @user.toggle!(:admin) }
    it { should be_admin }
  end

  describe "activated" do
    before { @user.activate! }
    it { should be_active }
  end

  shared_examples_for "valid with field" do |field, value|
    before { @user[field] = value }
    it { should be_valid }
  end

  shared_examples_for "invalid with field" do |field, value|
    before { @user[field] = value }
    it { should_not be_valid }
  end

  describe "with missing field" do
    fields = %i[name nick email]
    fields.each do |f|
      it_behaves_like "invalid with field", f, ''
    end
  end

  describe "when name is too long" do
    it_behaves_like "invalid with field", :name, "a" * (User::NAME_MAX_LEN + 1)
  end

  describe "when nick is too short" do
    it_behaves_like "invalid with field", :nick, "a" * (User::NICK_MIN_LEN - 1)
  end

  describe "when nick is too long" do
    it_behaves_like "invalid with field", :nick, "a" * (User::NICK_MAX_LEN + 1)
  end

  describe "when nick is invalid" do
    invalid_nicks = %w[ a simon&garfunkel one=two stop@me no! whynot? 用]
    invalid_nicks.each do |invalid_nick|
      it_behaves_like "invalid with field", :nick, invalid_nick
    end
  end

  describe "when nick is valid" do
    valid_nicks = %w[ user user21 user_name user-name MyName _whoami 用户 用户名 ]
    valid_nicks.each do |valid_nick|
      it_behaves_like "valid with field", :nick, valid_nick
    end
  end

  describe "when nick is already taken" do
    before do
      user_with_same_nick = @user.dup
      user_with_same_nick.nick = @user.nick.upcase
      user_with_same_nick.save
    end
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    invalid_addresses =  %w[user@foo,com user_at_foo.org example.user@foo.]
    invalid_addresses.each do |invalid_address|
      it_behaves_like "invalid with field", :email, invalid_address
    end
  end

  describe "when email format is valid" do
    valid_addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
    valid_addresses.each do |valid_address|
      it_behaves_like "valid with field", :email, valid_address
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  shared_examples_for "email confirmation with token" do |what|
    method    = "send_#{what.to_s}".to_sym
    field     = "#{what.to_s}_token".to_sym
    timestamp = "#{what.to_s}_sent_at".to_sym

    before { @user.send method }

    it "generates a unique token" do
      last_token = @user[field]
      @user.send method
      @user[field].should_not eq(last_token)
    end

    it "saves the time the confirmation was sent" do
      @user.reload[timestamp].should be_present
    end

    it "delivers email to user" do
      last_email.to.should include @user.email
    end
  end

  describe "password reset" do
    it_behaves_like "email confirmation with token", :password_reset
  end

  describe "activation" do
    it_behaves_like "email confirmation with token", :activation
  end

  describe "micropost associations" do
    before { @user.save }

    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "has the rigth microposts in the right order" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end

    it "destroys associated microposts" do
      microposts = @user.microposts
      @user.destroy
      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create(content: "Lorem ipsum") }
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end

  describe "search" do
    before :all do
      User.tire.index.delete
      User.create_elasticsearch_index
      FactoryGirl.create(:user, name: "Donald Duck")
      FactoryGirl.create(:user, name: "Mickey Mouse")
      User.tire.index.refresh
    end

    specify { User.search({}).count.should eql 2 }
    specify { User.search(query: '').count.should eql 2 }
    specify { User.search(query: 'donald').count.should eql 1 }
    specify { User.search(query: 'Tex Willer').count.should eql 0 }
  end
end
