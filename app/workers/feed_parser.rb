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

  feed_cursor = Feed.find_by(link: link)
  begin
    open(link, 'If-Modified-Since' => feed_cursor.modified_at.to_s, :allow_redirections => :all) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.each do |item|
        item_cursor = feed_cursor.items.find_by(link: item.link)
        if item_cursor.nil?
          item_cursor = feed_cursor.items.create(title: item.title,
                                                 link: item.link,
                                                 description: item.description,
                                                 created_at: item.date)
          publish(item_cursor)
        end
      end
      feed_cursor.update(title: feed.channel.title,
                         description: feed.channel.description,
                         language: feed.channel.language,
                         modified_at: rss.last_modified || feed_cursor.items&.order(created_at: :desc)&.first&.created_at || feed_cursor.created_at)
    end
  rescue OpenURI::HTTPError => ex
    if ex.message == '304 Not Modified'
      puts 'Not Modified'
    elsif ex.message == '404 Not Found'
      puts 'Not Found'
    else
      puts ex.message
    end
  rescue => ex
    puts ex.message
  end
end

def publish(item)
  User.all.each do |user|
    if Subscription.find_by(user_id: user.id, feed_id: item.feed.id)
      ItemState.create(user_id: user.id, item_id: item.id)
    end
  end
end