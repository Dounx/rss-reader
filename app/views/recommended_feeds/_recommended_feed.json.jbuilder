json.extract! recommended_feed, :id, :title, :description, :link, :created_at, :updated_at
json.url recommended_feed_url(recommended_feed, format: :json)
