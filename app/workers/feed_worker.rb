require 'rss'
require 'open-uri'

class FeedWorker
  include Sidekiq::Worker

  def perform(*args)
    link = args.first
    feed = Feed.find_by(link: link)

    if feed
      update_feed(feed)
    else
      create_feed(link)
    end
  end


  private

    def create_feed(link)
      open(link) do |rss|
        feed = RSS::Parser.parse(rss)

        feed_cursor = Feed.create(title: feed.channel.title,
                                  link: link,
                                  description: feed.channel.description,
                                  language: feed.channel.language,
                                  pub_date: feed.channel.date)

        feed.items.each do |item|
          feed_cursor.items.create(title: item.title,
                                   link: item.link,
                                   description: item.description,
                                   pub_date: item.date)
        end
      end
    end

    def update_feed(feed_cursor)
      open(feed_cursor.link) do |rss|
        feed = RSS::Parser.parse(rss)

        if feed.channel.date > feed_cursor.pub_date
          logger.info 'Update feed!'
          logger.info "before count: #{Item.count}"

          latest_item = Item.order(pub_date: :desc).first
          feed.items&.each do |item|
            if item.date > latest_item.pub_date
              feed_cursor.items.create(title: item.title,
                                       link: item.link,
                                       description: item.description,
                                       pub_date: item.date)
            end
          end
          feed_cursor.pub_date = feed.channel.date
          feed_cursor.save
          logger.info "after count: #{Item.count}"
        end
      end
    end
end
