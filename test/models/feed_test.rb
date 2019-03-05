require 'test_helper'

class FeedTest < ActiveSupport::TestCase
  setup do
    @feed = feeds(:one)
  end

  test "should destroy a feed and all it's items" do
    id = @feed.id
    @feed.destroy
    assert_nil Item.find_by(feed_id: id)
  end

  test "should destroy a feed and all it's subscriptions" do
    id = @feed.id
    @feed.destroy
    assert_nil Subscription.find_by(feed_id: id)
  end

  test "should add a feed if link is correct" do
    @feed.link = 'https://dounx.me'
    assert_equal @feed.save, true
  end

  test "should not add a feed if link is incorrect" do
    @feed.link = '2131313131'
    assert_equal @feed.save, false
  end

  test "should not add a feed if link is not unique" do
    assert_no_difference'Feed.count' do
      Feed.create(link: @feed.link, modified_at: @feed.modified_at)
    end
  end
end
