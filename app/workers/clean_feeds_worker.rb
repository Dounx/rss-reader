require 'feed_cleaner'

class CleanFeedsWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(*args)
    clean
  end
end
