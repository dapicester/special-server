require 'test_helper'

class UserControllerTest < ActionController::TestCase
  include ApplicationHelper

  setup do
    # this user is valid, but we may change its attributes
    @valid_user = users(:valid_user)
  end

  # Test the registration page and its form.
  test "should get register" do
    get :register
    assert_equal "Register", assigns(:title)
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
    # test session login
    assert logged_in?
    assert_equal user.id, session[:user_id]
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
    assert_tag :input, :attributes => { :name  => "user[password]" ,
                                        :value => nil },
                       :parent => error_div    
  end

  # Test the login page
  test "should get login" do
    get :login
    assert_equal "Login", assigns(:title)
    assert_response :success
    assert_template "login"
    assert_tag :form, :attributes => { :action => "/user/login",
                                       :method => "post" }
    assert_tag :input, :attributes => { :name => "user[screen_name]",
                                        :type => "text",
                                        :size => User::SCREEN_NAME_SIZE,
                                        :maxlength => User::SCREEN_NAME_MAX_LENGTH }
    assert_tag :input, :attributes => { :name => "user[password]",
                                        :type => "password",
                                        :size => User::PASSWORD_SIZE,
                                        :maxlength => User::PASSWORD_MAX_LENGTH }
    assert_tag :input, :attributes => { :type => "submit",
                                        :value => "Login" }
  end

  # Test a valid login.
  test "should login user valid" do
    try_to_login @valid_user
    assert logged_in?
    assert_equal @valid_user.id, session[:user_id]
    assert_equal "User #{@valid_user.screen_name} logged in!", flash[:notice]
    assert_redirected_to "action" => "index"
  end

  # Test a login with invalid screen name.
  test "should login failure with nonexistent screen name" do
    invalid_user = @valid_user
    invalid_user.screen_name = "nonexistent"
    try_to_login invalid_user
    assert_template "login"
    assert_equal "Invalid screen name/password combination", flash[:notice]
    # test that screen_name will be redisplayed, but not the password
    user = assigns(:user)
    assert_equal invalid_user.screen_name, user.screen_name
    assert_nil user.password
  end
  
  # Test a login with invalid password.
  test "should login failure with wrong password" do
    invalid_user = @valid_user
    invalid_user.password += "baz"
    try_to_login invalid_user
    assert_template "login"
    assert_equal "Invalid screen name/password combination", flash[:notice]
    # test that screen name will be redisplayed, but not the password
    user = assigns(:user)
    assert_equal invalid_user.screen_name, user.screen_name
    assert_nil user.password
  end

  # Test the logout function.
  test "should logout" do
    try_to_login @valid_user
    assert logged_in?
    get :logout
    assert_response :redirect
    assert_redirected_to :action => "index", :controller => "site"
    assert_equal "Logged out", flash[:notice]
    assert !logged_in?
  end
  
  # Test the navigation menu after login.
  test "navigation logged in" do
    authorize @valid_user
    get :index
    assert_tag :a, :content => /Logout/,
                   :attributes => { :href => "/user/logout" }
    assert_no_tag :a, :content => /Register/
    assert_no_tag :a, :content => /Login/
  end
  
  # Test index page for unauthorized user.
  test "index unauthorized" do
    # test before_filter
    get :index
    assert_response :redirect
    assert_redirected_to :action => "login"
    assert_equal "Please log in first", flash[:notice]
  end
  
  # Test index page for authorized user.
  test "index authorized" do
    authorize @valid_user
    get :index
    assert_response :success
    assert_template "index"
  end
  
  # Test forward back to protected page after login.
  test "login friendly url forwarding" do
    user = { :screen_name => @valid_user.screen_name,
             :password    => @valid_user.password }
    friendly_url_forwarding_aux(:login, :index, user)
  end
  
  # Test forward back to protected page after register.
  test "register friendly url forwarding" do
    user = { :screen_name => "new_screen_name",
             :email => "new@email.com",
             :password => "secret" }
    friendly_url_forwarding_aux(:register, :index, user)
  end
  
private
  
  # Try to log a user in using the login action.
  def try_to_login(user)
    post :login, :user => { :screen_name => user.screen_name,
                            :password    => user.password }
  end
  
  # Authorize a user.
  def authorize(user)
    @request.session[:user_id] = user.id
  end

  def friendly_url_forwarding_aux(test_page, protected_page, user)
    get protected_page
    assert_response :redirect
    assert_redirected_to :action => "login"
    post test_page, :user => user
    assert_response :redirect
    assert_redirected_to :action => protected_page
    # make sure the forwarding url has been cleared
    assert_nil session[:protected_page]
  end
end
  
