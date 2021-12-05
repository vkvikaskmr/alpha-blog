require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  test "successful signup" do
    get '/signup'
    assert_match "New user Sign up", response.body
    assert_difference "User.count", +1 do
      post users_path, params: { user: {username: "Test User", email: "test_user@grr.la", password: "password"}}
      assert_response :redirect
    end
    follow_redirect!
    assert_match "Welcome to alpha blog Test User, you have successfully signed up", response.body
  end

  test "cannot signup for existing username/email" do
    get '/signup'
    assert_match "New user Sign up", response.body
    assert_difference "User.count", +1 do
      post users_path, params: { user: {username: "Test User", email: "test_user@grr.la", password: "password"}}
      assert_response :redirect
    end
    follow_redirect!
    get '/signup'
    assert_no_difference "User.count" do
      post users_path, params: { user: {username: "Test User", email: "test_user@grr.la", password: "password"}}
    end
    assert_match "Username has already been taken", response.body
    assert_match "Email has already been taken", response.body
  end
end
