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
      feed_parser(args.first)
    else
      args.first.each do |link|
        feed_parser(link)
      end
    end
  end

  private
    def feed_parser(link)
      feed_cursor = Feed.find_or_create_by(link: link)
      begin
        open(link, 'If-Modified-Since' => feed_cursor.modified_at.to_s) do |rss|
          feed = RSS::Parser.parse(rss)
          feed_cursor.update(title: feed.channel.title,
                             description: feed.channel.description,
                             language: feed.channel.language,
                             modified_at: rss.last_modified)

          feed.items.each do |item|
            item_cursor = feed_cursor.items.find_by(link: item.link)
            feed_cursor.items.create(title: item.title,
                                                   link: item.link,
                                                   description: item.description,
                                                   updated_at: item.date) if item_cursor.nil?
          end
        end
      rescue OpenURI::HTTPError => ex
        if ex.message == '304 Not Modified'
          puts 'Not Modified'
        else
          puts ex.message
        end
      end
    end
end
