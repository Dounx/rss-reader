require 'open-uri'
require 'rss'

class Feed < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions

  validates :link, :format => URI::regexp(%w(http https)), uniqueness: {scope: :title, message: "should have only one unique feed"}

  def Feed.fetch(link)
    begin
      open(link, :allow_redirections => :all) do |rss|
        feed = RSS::Parser.parse(rss)
        unless Feed.find_by(title: feed.channel.title)
          feed_cursor = Feed.find_or_create_by(link: link)

          feed.items.each do |item|
            feed_cursor.items.create(title: item.title,
                                     link: item.link,
                                     description: item.description,
                                     created_at: item.date)
          end
          feed_cursor.update(title: feed.channel.title,
                             description: feed.channel.description,
                             language: feed.channel.language,
                             modified_at: rss.last_modified || feed_cursor.items&.order(created_at: :desc)&.first&.created_at)
          feed_cursor
        else
          feed = Feed.find_by(link: link)
          if feed
            'Should subscribe'
          else
            'Same title'
          end
        end
      end
    rescue OpenURI::HTTPError => ex
      if ex.message == '304 Not Modified'
        puts 'Not Modified'
      elsif ex.message == '404 Not Found'
        puts 'Not Found'
      else
        puts ex.message
      end
    rescue RSS::Error => ex
      puts ex.message
    rescue => ex
      puts ex.message
    end
  end

  def Feed.refresh
    Feed.all.each do |feed_cursor|
      begin
        open(feed_cursor.link, 'If-Modified-Since' => feed_cursor.modified_at.to_s, :allow_redirections => :all) do |rss|
          feed = RSS::Parser.parse(rss)
          feed.items.each do |item|
            feed_cursor.items.create(title: item.title,
                                     link: item.link,
                                     description: item.description,
                                     created_at: item.date)
          end
          feed_cursor.update(title: feed.channel.title,
                             description: feed.channel.description,
                             language: feed.channel.language,
                             modified_at: rss.last_modified || feed_cursor.items&.order(created_at: :desc)&.first&.created_at)
        end
      rescue OpenURI::HTTPError => ex
        if ex.message == '304 Not Modified'
          puts 'Not Modified'
        elsif ex.message == '404 Not Found'
          puts 'Not Found'
        else
          puts ex.message
        end
      rescue RSS::Error => ex
        puts ex.message
      rescue => ex
        puts ex.message
      end
      PublishItemsWorker.perform_async(feed_cursor.id)
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

  def publish
    User.all.each do |user|
      if (subscription = user.subscriptions.find_by(feed_id: id))
        last_updated_at = subscription.updated_at
        subscription.update(updated_at: DateTime.now)
        items.each do |item|
          item.item_states.create(user_id: user.id) if item.updated_at > last_updated_at # must be updated_at not crated_at(item.date)
        end
      end
    end
  end
end
