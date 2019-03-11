class PublishItemsWorker
  include Sidekiq::Worker

  def perform(*args)
    Feed.find(args.first).publish
  end
end
