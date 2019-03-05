require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end

  test "should get index if not login" do
    get root_url
    assert_response :success
  end

  test "should get index if login" do
    sign_in @user
    get root_url
    assert_response :success
  end

end
