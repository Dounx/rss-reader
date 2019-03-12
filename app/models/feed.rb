require 'open-uri'
require 'rss'

class Feed < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions

  validates :link, :format => URI::regexp(%w(http https)), uniqueness: {scope: :title, message: "should have only one unique feed"}

  FetchStatus = {
      Success: 'Success',
      NotModified: '304 Not Modified',
      NotFound: '404 Not Found',
      HTTPError: 'Http Error',
      ENOENT: 'Wrong link',
      SocketError: 'Failed to open TCP connection',
      NotWellFormedError: 'This is not well formed XML',
      TooMuchTagError: 'This XML has too much tag errors',
      NotAvailableValueError: 'This XML has some value errors',
      MissingTagError: 'Tag is missing in some tag',
      FeedExistedError: 'Feed existed'
  }

  def Feed.fetch(link)
    add_prefix_retry_times = 2
    begin
      # 'If-Modified-Since' => feed_cursor.modified_at.to_s cannot worked, strange!
      open(link, :allow_redirections => :all) do |rss|
        feed = RSS::Parser.parse(rss)
        Feed.parse(rss, feed, link)
      end
      FetchStatus[:Success]
    rescue OpenURI::HTTPError => ex
      if ex.message == '304 Not Modified'
        FetchStatus[:NotModified]
      elsif ex.message == '404 Not Found'
        FetchStatus[:NotFound]
      else
        FetchStatus[:HTTPError]
      end
    rescue Errno::ENOENT => ex
      if add_prefix_retry_times == 2
        link = 'https://' + link
        add_prefix_retry_times -= 1
        retry
      elsif add_prefix_retry_times == 1
        link = 'http://' + link.delete_prefix('https://')
        add_prefix_retry_times -= 1
        retry
      else
        FetchStatus[:ENOENT]
      end
    rescue SocketError => ex
      FetchStatus[:SocketError]
    rescue RSS::NotWellFormedError => ex
      FetchStatus[:NotWellFormedError]
    rescue RSS::TooMuchTagError => ex
      FetchStatus[:TooMuchTagError]
    rescue RSS::NotAvailableValueError => ex
      FetchStatus[:NotAvailableValueError]
    rescue RSS::MissingTagError => ex
      FetchStatus[:MissingTagError]
    rescue RuntimeError => ex
      FetchStatus[:FeedExistedError]
    end
  end

  def Feed.refresh
    Feed.all.each do |feed|
      Feed.fetch(feed.link)
      PublishItemsWorker.perform_async(feed.id)
    end
  end

  def Feed.clean
    Feed.all.each do |feed|
      if feed.subscriptions.count == 0
        puts "Clean a useless feed #{feed.link}"
        feed.destroy
      end
    end
  end

  def publish
    User.all.each do |user|
      subscription = user.subscriptions.find_by(feed_id: id)
      if subscription
        last_updated_at = subscription.updated_at
        subscription.update(updated_at: DateTime.now)
        items.each do |item|
          begin
            item.item_states.create(user_id: user.id) if item.created_at > last_updated_at
          rescue => ex
            puts ex.message
          end
        end
      end
    end
  end

  def subscribe(user_id)
    subscription = subscriptions.new(user_id: user_id)
    if subscription.save
      PublishItemsWorker.perform_async(id)
    else
      nil
    end
  end

  def unsubscribe(user_id)
    items.each do |item|
      item.item_states.find_by(user_id: user_id)&.destroy
    end
    subscriptions.find_by(user_id: user_id).destroy
    CleanFeedsWorker.perform_async
  end

  private

  def Feed.parse(rss, feed, link)
    feed_cursor = Feed.find_or_initialize_by(link: link)
    # try parse modified_at
    # rss.last_modified -> feed.channel.lastBuildDate -> feed.items.first.updated -> feed.items.first.published -> DateTime.now
    if rss.methods.include?(:last_modified) && rss.last_modified
      feed_cursor.modified_at = rss.last_modified
    elsif feed.methods.include?(:channel) && feed.channel
      if feed.channel.methods.include?(:lastBuildDate) && feed.channel.lastBuildDate
        feed_cursor.modified_at = feed.channel.lastBuildDate
      elsif feed.channel.methods.include?(:pubDate) && feed.channel.pubDate
        feed_cursor.modified_at = feed.channel.pubDate
      elsif feed.methods.include?(:items) && feed.items.any?
        # here maybe have some problem because item.first maybe is not the newest item
        if feed.items.first.methods.include?(:updated) && feed.items.first.updated
          feed_cursor.modified_at = feed.items.first.updated.content
        elsif feed.items.first.methods.include?(:published) && feed.items.first.published
          feed_cursor.modified_at = feed.items.first.content
        else
          feed_cursor.modified_at = DateTime.now
        end
      end
    else
      feed_cursor.modified_at = DateTime.now  # In rails should be DateTime.now
    end

    # try parse feed's title, link and description
    if feed.methods.include?(:channel) && feed.channel
      feed_cursor.title = feed.channel.title.strip
      feed_cursor.link = feed.channel.link.strip
      feed_cursor.description = feed.channel.description.strip
    else
      feed_cursor.title = feed.title.content.strip if feed.methods.include?(:title) && feed.title&.content
      feed_cursor.link = feed.link.href.strip
      feed_cursor.description = feed.subtitle.content.strip if feed.methods.include?(:subtitle) && feed.subtitle&.content
    end

    unless feed_cursor.save
      raise FetchStatus[:FeedExistedError]
    end

    # try parse item's title, link, description and created_at and updated_at
    feed.items.each do |item|
      # there need some deal in rails
      item_cursor = feed_cursor.items.new
      if item.title.methods.include?(:content) && item.title.content
        item_cursor.title = item.title.content.strip
      else
        item_cursor.title = item.title.strip
      end

      if item.link.methods.include?(:href) && item.link.href
        item_cursor.link = item.link.href.strip
      else
        item_cursor.link = item.link.strip
      end


      if item.methods.include?(:description) && item.description
        item_cursor.description = item.description.strip
      elsif item.methods.include?(:content) && item.content
        item_cursor.description = item.content.content.strip.strip
      end

      item_cursor.created_at = item.published.content if item.methods.include?(:published) && item.published&.content
      item_cursor.created_at = item.date if item.methods.include?(:date) && item.date
      item_cursor.updated_at = item.updated.content if item.methods.include?(:updated) && item.updated.content

      begin
        item_cursor.save
      rescue
        item_cursor.description = '<a href=' + item_cursor.link + '>' + 'Go to Site</a>' + '<br/>' + item_cursor.description
        item_cursor.link = '#'
        item_cursor.save
      end
    end
  end
end
