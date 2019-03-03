=begin
This worker need a method to find out if a feed should be update.
Some of feeds can't be parsed by rss gem.
=end

require 'rss'
require 'open-uri'

class FeedWorker
  include Sidekiq::Worker

  def perform(*args)
    if args.first.is_a?(String)
      deal_with_feed(args.first)
    else
      args.first.each do |link|
        deal_with_feed(link)
      end
    end
  end


  private

    def deal_with_feed(link)
      feed = Feed.find_by(link: link)
      if feed
        update_feed(feed)
      else
        create_feed(link)
      end
    end

    def create_feed(link)
      open(link) do |rss|
        feed = RSS::Parser.parse(rss)

        feed_cursor = Feed.create(title: feed.channel.title,
                                  link: link,
                                  description: feed.channel.description,
                                  language: feed.channel.language,
                                  modified_at: rss.last_modified)

        feed.items.each do |item|
          feed_cursor.items.create(title: item.title,
                                   link: item.link,
                                   description: item.description,
                                   created_at: item.date)
        end
      end
    end

    def update_feed(feed_cursor)
      open(feed_cursor.link, 'If-Modified-Since' => feed_cursor.modified_at.to_s) do |rss|
        feed = RSS::Parser.parse(rss)
        # logger.info 'Update feed!'
        # logger.info "before count: #{Item.count}"
        #
        unless feed.nil?
          last_item = feed_cursor.items.order(created_at: :desc).first

          feed.items.each do |item|
            if item.date > last_item.created_at
              feed_cursor.items.create(title: item.title,
                                       link: item.link,
                                       description: item.description,
                                       created_at: item.date)
            end
          end
          feed_cursor.modified_at = rss.last_modified
          feed_cursor.save!
        end

        # feed_cursor.pub_date = feed.channel.date
        # feed_cursor.save
        # logger.info "after count: #{Item.count}"
      end
    end
end
