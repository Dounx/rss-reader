require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @item = items(:one)
    @user = users(:one)
  end

  test "should get index if login" do
    sign_in @user
    get items_url
    assert_response :success
  end

  test "should show item if login" do
    sign_in @user
    get item_url(@item)
    assert_response :success
  end

  test "should destroy item if login" do
    sign_in @user
    assert_difference('ItemState.count', -1) do
      delete item_url(@item)
    end
    assert_redirected_to items_url
  end

  test "should not get index if not login" do
    get items_url
    assert_response :found
    assert_redirected_to new_user_session_url
  end

  test "should not show item  if not login" do
    get item_url(@item)
    assert_response :found
    assert_redirected_to new_user_session_url
  end

  test "should not destroy item if not login" do
    assert_no_difference('ItemState.count') do
      delete item_url(@item)
      assert_response :found
    end
    assert_redirected_to new_user_session_url
  end
end
