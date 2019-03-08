require 'test_helper'

class FeedsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @feed = feeds(:one)
    @user = users(:one)
  end

  test "should get index if login" do
    sign_in @user
    get feeds_url
    assert_response :success
  end

  test "should show feed if login" do
    sign_in @user
    get feed_url(@feed)
    assert_response :success
  end

  test "should get new if login" do
    sign_in @user
    get new_feed_url
    assert_response :success
  end

  test "should create feed if login" do
    sign_in @user
    assert_difference('Feed.count') do
      post feeds_url, params: { feed: {link: 'https://www.ithome.com/rss/' } }
    end
    assert_redirected_to user_url(@user)
  end

  test "should destroy feed if login" do
    sign_in @user
    assert_difference('Subscription.count', -1) do
      delete feed_url(@feed)
    end

    assert_redirected_to user_url(@user)
  end

  test "should not get index if not login" do
    get feeds_url
    assert_response :found
    assert_redirected_to new_user_session_path
  end

  test "should not show feed if not login" do
    get feed_url(@feed)
    assert_response :found
    assert_redirected_to new_user_session_path
  end

  test "should not get new if not login" do
    get new_feed_url
    assert_response :found
    assert_redirected_to new_user_session_path
  end

  test "should not get edit if not login" do
    get edit_feed_url(@feed)
    assert_response :found
    assert_redirected_to new_user_session_path
  end

  test "should not create feed if not login" do
    assert_no_difference('Feed.count') do
      post feeds_url, params: { feed: {link: 'https://www.ithome.com/rss/' } }
      assert_response :found
    end
    assert_redirected_to new_user_session_path
  end


  test "should not destroy feed if not login" do
    assert_no_difference('Subscription.count') do
      delete feed_url(@feed)
      assert_response :found
    end
    assert_redirected_to new_user_session_path
  end
end
