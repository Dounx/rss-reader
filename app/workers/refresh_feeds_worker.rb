require 'feed_parser'

  class RefreshFeedsWorker
    include Sidekiq::Worker
    sidekiq_options retry: 3

    def perform(*args)
      feed_parser(Feed.all.map(&:link))
    end
  end