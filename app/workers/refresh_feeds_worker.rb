require 'feed_parser'
require 'feed_clean'

  class RefreshFeedsWorker
    include Sidekiq::Worker
    sidekiq_options retry: 3

    def perform(*args)
      clean
      if args.first.nil?
        feed_parser(Feed.all.map(&:link))
      else
        feed_parser(args.first)
      end
    end
  end