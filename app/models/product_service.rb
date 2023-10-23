# app/services/product_graphql_service.rb
require 'graphql/client/http'

module ProductGraphQLService
  HTTP = GraphQL::Client::HTTP.new("https:ecigmafia.com/graphql") do
    def headers(context)
      {
        "Authorization" => "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJjaIjoxLCJjb3JzIjpbInRydXN0Il0sImVhIjoxNjI5OTY5OTY0LCJpcyI6IkJDIiwic2kiOjk5OTczOTUwOCwic3YiOiJiY2FwYS5saW5rZXJkIiwidXNlX3R5cGUiOjEsInRva2VuX3R5cGUiOjF9.cfcX8W4iR0VcK-BjFmrvikTy5y8PKi5KcL0iXOtZcdkX0-FTYR-DGM_t4Gr2BA_P2AoaW1wnR_Sb9GlCC4h2ajw"
      }
    end 
  end

  Schema = GraphQL::Client.load_schema(HTTP)
  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)

  def self.fetch_product_data(entity_id)
    query = Client.parse <<~GRAPHQL
      query {
        site {
          products(entityIds: #{entity_id}) {
            edges {
              node {
                name
                price {
                  value
                }
                retailPrice {
                  value
                }
                path
                defaultImage {
                  url(width: 100)
                }
                currencyCode
              }
            }
          }
        }
      }
    GRAPHQL

    response = Client.query(query)
    data = response.data.site.products.edges.first&.node
    return nil if data.nil?

    {
      name: data.name,
      price: data.price.value,
      retail_price: data.retailPrice.value,
      path: data.path,
      default_image_url: data.defaultImage.url,
      currency_code: data.currencyCode
    }
  end
end
