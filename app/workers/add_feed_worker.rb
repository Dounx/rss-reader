require 'feed_parser'

class AddFeedWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(*args)
    feed_parser(args.first)
  end
end
