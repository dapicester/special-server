require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @valid_user = users(:valid_user)
    @invalid_user = users(:invalid_user)
  end

  # User valid by construction.
  test "user validity" do
    assert @valid_user.valid?
  end

  # User invalid by construction.
  test "user invalidity" do
    assert !@invalid_user.valid?
    attributes = [:screen_name, :email, :password]
    attributes.each do |a|
      assert @invalid_user.errors.has_key?(a)
    end
  end

  test "uniqueness of screen_name and email" do
    user_repeat = User.new(:screen_name => @valid_user.screen_name,
                           :email       => @valid_user.email,
                           :password    => @valid_user.password)
    assert !user_repeat.valid?
    # error messages
    assert_equal [I18n.translate("activerecord.errors.messages.taken")], user_repeat.errors[:screen_name]
    assert_equal ["has already been taken"], user_repeat.errors[:email]
  end

  test "screen name minimum length" do
    user = @valid_user
    min_length = User::SCREEN_NAME_MIN_LENGTH
    # too short
    user.screen_name = "a" * (min_length - 1)
    assert !user.valid?, "#{user.screen_name} should raise a minimum length error"
    # error message
    correct_error_message = I18n.translate("errors.messages.too_short", :count => min_length)
    assert_equal [correct_error_message], user.errors[:screen_name]
    # minimum length
    user.screen_name = "a" * min_length
    assert user.valid?, "#{user.screen_name} should be just long enough to pass"
  end

  test "screen name maximum length" do
    user = @valid_user
    max_length = User::SCREEN_NAME_MAX_LENGTH
    # too long
    user.screen_name = "a" * (max_length + 1)
    assert !user.valid?, "#{user.screen_name} should raise a maximum length error"
    # error message
    correct_error_message = I18n.translate("errors.messages.too_long", :count => max_length)
    assert_equal [correct_error_message], user.errors[:screen_name]
    # maximum length
    user.screen_name = "a" * max_length
    assert user.valid?, "#{user.screen_name} should be just long enough to pass"
  end

  test "password minimum length" do
    user = @valid_user
    min_length = User::PASSWORD_MIN_LENGTH
    # too short
    user.password = "a" * (min_length - 1)
    assert !user.valid?, "#{user.password} should raise a minimum length error"
    # error message
    correct_error_message = I18n.translate("errors.messages.too_short", :count => min_length)
    assert_equal [correct_error_message], user.errors[:password]
    # minimum length
    user.password = "a" * min_length
    assert user.valid?, "#{user.password} shoud be just long enough to pass"
  end
  
  test "password maximum length" do
    user = @valid_user
    max_length = User::PASSWORD_MAX_LENGTH
    # too long
    user.password = "a" * (max_length + 1)
    assert !user.valid?, "#{user.password} should raise a maximum length error"
    # error message
    correct_error_message = I18n.translate("errors.messages.too_long", :count => max_length)
    assert_equal [correct_error_message], user.errors[:password]
    # maximum length
    user.password = "a" * max_length
    assert user.valid?, "#{user.password} shoud be just long enough to pass"
  end

  test "email maximum length" do
    user = @valid_user
    max_length = User::EMAIL_MAX_LENGTH
    # too long
    user.email = "a" * (max_length - user.email.length + 1) + user.email
    assert !user.valid?, "#{user.email} should raise a maximum length error"
    # error message
    correct_error_message = I18n.translate("errors.messages.too_long", :count => max_length)
    assert_equal [correct_error_message], user.errors[:email]
  end

  test "email with valid examples" do
    user = @valid_user
    valid_endings = %w{com org net edu es it jp info}
    valid_emails = valid_endings.collect do |ending|
      "foo.bar_1-9@bax-quux0.example.#{ending}"
    end
    valid_emails.each do |email|
      user.email = email
      assert user.valid?, "#{email} must be a valid email address"
    end
  end

  test "email with invalid examples" do
    user = @valid_user
    invalid_emails = %w{foobar@example.c @example.com f@com foo@bar..com foobar@example.infod foobar.example.com foo,@example.com foo@ex(ample.com foo@example,com}
    invalid_emails.each do |email|
      user.email = email
      assert !user.valid?, "#{email} tests as valid but shouldn't be"
      assert_equal ["must be a valid email address"], user.errors[:email]
    end
  end
  
  test "screen_name with valid examples" do
    user = @valid_user
    valid_scree_names = %w{paolo michael web_20}
    valid_scree_names.each do |screen_name|
      user.screen_name = screen_name
      assert user.valid?, "#{screen_name} should pass validation, but doesn't"
    end
  end

  test "scree_name with invalid examples" do
    user = @valid_user
    invalid_scree_names = %w{rails/rocks web2.0 javascript:something}
    invalid_scree_names.each do |screen_name|
      user.screen_name = screen_name
      assert !user.valid?, "#{screen_name} shouldn't pass validation, but does"
    end
  end
end
