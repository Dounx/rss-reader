require 'test_helper'

class FeedsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @feed = feeds(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get feeds_url
    assert_response :success
  end

  test "should get new" do
    get new_feed_url
    assert_response :success
  end

  test "should create feed" do
    assert_difference('Feed.count') do
      post feeds_url, params: { feed: { description: @feed.description, language: @feed.language, link: @feed.link, title: @feed.title } }
    end

    assert_redirected_to feed_url(Feed.last)
  end

  test "should show feed" do
    get feed_url(@feed)
    assert_response :success
  end

  test "should get edit" do
    get edit_feed_url(@feed)
    assert_response :success
  end

  test "should update feed" do
    patch feed_url(@feed), params: { feed: { description: @feed.description, language: @feed.language, link: @feed.link, title: @feed.title } }
    assert_redirected_to feed_url(@feed)
  end

  test "should destroy feed" do
    assert_difference('Feed.count', -1) do
      delete feed_url(@feed)
    end

    assert_redirected_to feeds_url
  end
end
