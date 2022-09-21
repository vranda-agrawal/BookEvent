json.extract! event, :id, :event_name, :description, :event_date, :event_time, :price, :user_id, :created_at, :updated_at
json.url event_url(event, format: :json)
