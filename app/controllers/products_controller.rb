#products_controller.rb
class ProductsController < ApplicationController
  require 'httparty'  # Add this line to require the HTTParty gem

  # ... other actions ...

  def fetch_product_price
    entity_id = params[:entity_id]
    #entity_id = 4786

    # Replace the following query with your actual GraphQL query.
    graphql_query = <<~GRAPHQL
      {
        site {
          products(entityIds: #{entity_id}) {
            edges {
              node {
                name
                prices {
                  price {
                    value
                    currencyCode
                  }
                }
              }
            }
          }
        }
      }
    GRAPHQL

    authorization_token = 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJjaWQiOjEsImNvcnMiOlsiaHR0cHM6Ly93d3cuZWNpZ21hZmlhLmNvbSJdLCJlYXQiOjE2OTgyMzA2OTMsImlhdCI6MTY5ODA1Nzg5MywiaXNzIjoiQkMiLCJzaWQiOjk5OTcwNTkzOCwic3ViIjoiYmNhcHAubGlua2VyZCIsInN1Yl90eXBlIjowLCJ0b2tlbl90eXBlIjoxfQ.cY55gRQfc89_xRCTl0tN3UUvGvUh2nN3suaNEWjrzQDEWxVUDTyvEQL8NeCISKPKXroMchizPUMpCUA_z1cHlg'

    response = HTTParty.post('https://ecigmafia.com/graphql', body: { query: graphql_query }.to_json, headers: { 'Authorization' => authorization_token, 'Content-Type' => 'application/json' })

    data = JSON.parse(response.body)

    if data['data'] && data['data']['site']['products']['edges'].present?
      product_data = data['data']['site']['products']['edges'].first['node']

      @product_price = product_data['prices']['price']['value']
      @product_name = product_data['name']

      flash[:notice] = 'Product price fetched successfully.'
    else
      flash[:alert] = 'No product data found for this entity ID.'
    end

    render 'product_price_page', turbo_stream: false
  rescue StandardError => e
    flash[:alert] = "Error fetching product price: #{e.message}"
    render 'product_price_page'
  end
end

# ... other actions ...
