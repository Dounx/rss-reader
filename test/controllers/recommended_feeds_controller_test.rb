require 'test_helper'

class RecommendedFeedsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recommended_feed = recommended_feeds(:one)
  end

  test "should get index" do
    get recommended_feeds_url
    assert_response :success
  end

  test "should get new" do
    get new_recommended_feed_url
    assert_response :success
  end

  test "should create recommended_feed" do
    assert_difference('RecommendedFeed.count') do
      post recommended_feeds_url, params: { recommended_feed: { description: @recommended_feed.description, link: @recommended_feed.link, title: @recommended_feed.title } }
    end

    assert_redirected_to recommended_feed_url(RecommendedFeed.last)
  end

  test "should show recommended_feed" do
    get recommended_feed_url(@recommended_feed)
    assert_response :success
  end

  test "should get edit" do
    get edit_recommended_feed_url(@recommended_feed)
    assert_response :success
  end

  test "should update recommended_feed" do
    patch recommended_feed_url(@recommended_feed), params: { recommended_feed: { description: @recommended_feed.description, link: @recommended_feed.link, title: @recommended_feed.title } }
    assert_redirected_to recommended_feed_url(@recommended_feed)
  end

  test "should destroy recommended_feed" do
    assert_difference('RecommendedFeed.count', -1) do
      delete recommended_feed_url(@recommended_feed)
    end

    assert_redirected_to recommended_feeds_url
  end
end
