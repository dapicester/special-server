require 'test_helper'

class SiteControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_tag :h1, :content => "Welcome to Special!"
    assert_response :success
    assert_template "index"
  end

  test "should get about" do
    get :about
    assert_tag :h1, :content => "About us"
    assert_response :success
    assert_template "about"
  end

  test "should get help" do
    get :help
    assert_tag :h1, :content => "Help"
    assert_response :success
    assert_template "help"
  end

  test "navigation not logged in" do
    get :index
    assert_tag :a, :content => /Register/, 
                   :attributes => { :href => "/user/register" }
    assert_tag :a, :content => /Login/,
                   :attributes => { :href => "/user/login" }
    # test link_to_unless_current
    assert_no_tag :a, :content => /Home/
  end
end
