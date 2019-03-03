=begin
This worker need a method to find out if a feed should be update.
Update Item States should be quicker.
=end

require 'open-uri'
require 'rss'

def feed_parser(links)

  if links.is_a?(String)
    core(links)
  else
    links.each do |link|
      core(link)
    end
  end
end

def core(link)
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
        if item_cursor.nil?
          item_cursor = feed_cursor.items.create(title: item.title,
                                                 link: item.link,
                                                 description: item.description,
                                                 updated_at: item.date)
          update_item_states(item_cursor)
        end
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

def update_item_states(item)
  User.all.each do |user|
    if Subscription.find_by(user_id: user.id, feed_id: item.feed.id)
      ItemState.create(user_id: user.id, item_id: item.id)
    end
  end
end