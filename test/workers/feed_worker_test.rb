=begin
All this tests need network connection!
=end

require 'test_helper'
class FeedWorkerTest < ActiveSupport::TestCase
  link = 'https://www.ithome.com/rss/'

  test 'should add a feed' do
    assert_difference'Feed.count' do
      FeedWorker.new.perform(link)
    end
  end

  test 'should not add a feed if the feed existed ' do
    FeedWorker.new.perform(link)
    assert_no_difference'Feed.count' do
      FeedWorker.new.perform(link)
    end
  end

  test 'should add items' do
    last_count = Item.count
    FeedWorker.new.perform(link)
    assert_not_equal last_count, Item.count
  end


  test 'should not add items if items exist' do
    FeedWorker.new.perform(link)
    assert_no_difference'Item.count' do
      FeedWorker.new.perform(link)
    end
  end
end
