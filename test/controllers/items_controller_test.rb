require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @item = items(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get items_url
    assert_response :success
  end

  test "should show item" do
    get item_url(@item)
    assert_response :success
  end

  test "should destroy item" do
    assert_difference('ItemState.count', -1) do
      delete item_url(@item)
    end

    assert_redirected_to items_url
  end
end
