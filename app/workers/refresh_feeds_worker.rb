class RefreshFeedsWorker
    include Sidekiq::Worker

    def perform(*args)
      Feed.refresh
    end
  end