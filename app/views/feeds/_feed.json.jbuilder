json.extract! feed, :id, :title, :link, :description, :language, :created_at, :updated_at
json.url feed_url(feed, format: :json)
