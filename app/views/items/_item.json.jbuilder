json.extract! item, :id, :title, :link, :description, :created_at, :updated_at
json.url item_url(item, format: :json)
