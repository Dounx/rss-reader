class FetchFeedsWorker
  include Sidekiq::Worker

  def perform(*args)
    Feed.fetch(args.first)
  end
end
