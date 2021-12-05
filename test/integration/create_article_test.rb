require 'test_helper'

class CreateArticleTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(username: "Test", email: "test@grr.la",
                        password: "password")
  end
  test "articles new page cannot be displayed without logging in" do
    get '/articles/new'
    assert_redirected_to login_path
    follow_redirect!
    assert_response :success
    assert_match "You must be logged in to perform this operation", response.body
  end

  test "articles new page can be displayed and article created for logged in user" do
    sign_in_as(@user)
    get '/articles/new'
    assert_match "Create a new Article", response.body
    assert_difference "Article.count", +1 do
      post articles_path, params: { article: {title: "Feeling awesome", description: "Did yoga today and feeling awesome"} }
      assert_response :redirect
    end
    follow_redirect!
    assert_match "Article created successfully!", response.body
  end
end
