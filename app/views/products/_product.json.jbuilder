json.extract! product, :id, :handle, :name, :price, :retail_price, :description, :category, :path, :default_image_url, :currency, :entity_id, :created_at, :updated_at
json.url product_url(product, format: :json)
