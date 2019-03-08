require 'test_helper'

class RecommendedFeedsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @recommended_feed = recommended_feeds(:one)
    sign_in(users(:one))
  end

  test "should get index" do
    get recommended_feeds_url
    assert_response :success
  end

  test "should subscribe" do
    assert_difference('Subscription.count') do
      post recommended_feeds_url, params: {link: @recommended_feed.link}
    end

    assert_redirected_to recommended_feeds_url
  end
end
