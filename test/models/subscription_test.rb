require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  setup do
    @subscription = subscriptions(:one)
  end

  test "should not add a subscription if feed_id and users_id is not unique" do
    assert_no_difference'Subscription.count' do
      Subscription.create(feed_id: @subscription.feed_id, user_id: @subscription.user_id)
    end
  end
end
