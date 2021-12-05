require 'test_helper'

class ListCategoriesTest < ActionDispatch::IntegrationTest
  def setup
    @category = Category.create(name: "Sports")
    @category2 = Category.create(name: "Travel")
  end

  test "should list all categories" do
    get '/categories'
    assert_select "a[href=?]", category_path(@category)
    assert_select "a[href=?]", category_path(@category2)
  end
end
