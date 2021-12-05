require 'test_helper'

class CreateCategoryTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = User.create(username: "Test", email: "test@grr.la",
                              password: "password", admin: true)
    sign_in_as(@admin_user)
  end

  test "new category page can be displayed and category can be created" do
    get '/categories/new'
    assert_response :success
    assert_difference "Category.count", +1 do
      post categories_path, params: { category: {name: "Travel"} }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "Travel", response.body
  end

  test "invalid category cannot be created" do
    get '/categories/new'
    assert_response :success
    assert_no_difference "Category.count" do
      post categories_path, params: { category: {name: " "} }
    end
    assert_match "errors", response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end
end
