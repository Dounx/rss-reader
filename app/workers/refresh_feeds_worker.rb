require 'feed_parser'

  class RefreshFeedsWorker
    include Sidekiq::Worker
    sidekiq_options retry: 3

    def perform(*args)
      if args.first.nil?
        feed_parser(Feed.all.map(&:link))
      else
        feed_parser(args.first)
      end
    end
  end