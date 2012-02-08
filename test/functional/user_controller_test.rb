require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  # Test the registration page and its form.
  test "should get register" do
    get :register
    assert_tag :h2, :content => "Register"
    assert_response :success
    assert_template "register"
    # form
    assert_tag :form, :attributes => { :action => "/user/register",
                                       :method => "post" }
    assert_tag :input, :attributes => { :name => "user[screen_name]",
                                        :type => "text",
                                        :size => User::SCREEN_NAME_SIZE,
                                        :maxlength => User::SCREEN_NAME_MAX_LENGTH }
    assert_tag :input, :attributes => { :name => "user[email]",
                                        :type => "text",
                                        :size => User::EMAIL_SIZE,
                                        :maxlength => User::EMAIL_MAX_LENGTH }
    assert_tag :input, :attributes => { :name => "user[password]",
                                        :type => "password",
                                        :size => User::PASSWORD_SIZE,
                                        :maxlength => User::PASSWORD_MAX_LENGTH }
    assert_tag :input, :attributes => { :type => "submit",
                                        :value => "Register" }
  end

  # Test a valid registration.
  test "should register user success" do
    post :register, :user => { :screen_name => "test_user",
                               :email       => "user@test.com",
                               :password    => "secret" }
    # test assignment
    user = assigns(:user)
    assert_not_nil user
    # test user in database
    new_user = User.find_by_screen_name_and_password(user.screen_name, user.password)
    assert_equal new_user, user
    # test flash and redirect
    assert_equal "User #{new_user.screen_name} created!", flash[:notice]
    assert_redirected_to :action => "index"
  end

  # Test an invalid registration
  test "should register user failure" do
    post :register, :user => { :screen_name => "invalid/user",
                               :email       => "invalid@email",
                               :password    => "small" }
    assert_response :success
    assert_template "register"
    # test error messages
    assert_tag :div, :attributes => { :id => "error_explanation" }
    # test form field errors
    assert_tag :li, :content => /Screen name/
    assert_tag :li, :content => /Email/
    assert_tag :li, :content => /Password/
    # test correct divs
    error_div = { :tag => "div", :attributes => { :class => "field_with_errors" } }
    assert_tag :input, :attributes => { :name  => "user[screen_name]",
                                        :value => "invalid/user" },
                       :parent => error_div
    assert_tag :input, :attributes => { :name  => "user[email]",
                                        :value => "invalid@email" },
                       :parent => error_div
    assert_tag :input, :attributes => { :name  => "user[password]" },
                                        # password inputs do not keep value
                       :parent => error_div    
  end
end
