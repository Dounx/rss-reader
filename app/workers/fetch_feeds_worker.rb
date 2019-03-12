class FetchFeedsWorker
  include Sidekiq::Worker

  def perform(*args)
    Feed.find_by_link(args.first).subscribe(args.last) if Feed.fetch(args.first) == Feed::FetchStatus[:success]
  end
end
