# products_controller.rb
class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    @products = Product.all
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def fetch
    begin
      authorization_token = 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJjaWQiOjEsImNvcnMiOlsiaHR0cHM6Ly93d3cuZWNpZ21hZmlh.lmVB... (Your token here)'

      response = HTTP.post(
        'https://ecigmafia.com/graphql',
        json: { query: "{ site { products(entityIds: #{@product.entity_id}) { edges { node { name prices { price { value currencyCode } retailPrice { value } } path defaultImage { url(width: 100) } } } } } }" },
        headers: { 'Authorization' => authorization_token }
      )

      data = JSON.parse(response.body)

      if data['data'] && data['data']['site']['products']['edges'].present?
        product_data = data['data']['site']['products']['edges'].first['node']

        @product.update(
          name: product_data['name'],
          price: product_data['prices']['price']['value'],
          retail_price: product_data['prices']['retailPrice']['value'],
          path: product_data['path'],
          default_image_url: product_data['defaultImage']['url'],
          currency: product_data['prices']['price']['currencyCode']
        )

        flash[:notice] = 'Product data fetched successfully.'
      else
        flash[:alert] = 'No product data found for this entity ID.'
      end
    rescue StandardError => e
      flash[:alert] = "Error fetching product data: #{e.message}"
    end

    redirect_to @product
  end

  # ...


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:handle, :name, :price, :retail_price, :description, :category, :path, :default_image_url, :currency, :entity_id)
    end
end




# pussy

class ProductsController < ApplicationController
  require 'httparty'  # Add this line to require the HTTParty gem

  # ... other actions ...

  def fetch_product_price
    #entity_id = 4786

    # Replace the following query with your actual GraphQL query.
    graphql_query = <<~GRAPHQL
      {
        site {
          products(entityIds: 4786) {
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

    authorization_token = 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJjaWQiOjEsImNvcnMiOlsiaHR0cHM6Ly93d3cuZWNpZ21hZmlhLmNvbSJdLCJlYXQiOjE2OTgwNTgwODEsImlhdCI6MTY5Nzg4NTI4MSwiaXNzIjoiQkMiLCJzaWQiOjk5OTcwNTkzOCwic3ViIjoiYmNhcHAubGlua2VyZCIsInN1Yl90eXBlIjowLCJ0b2tlbl90eXBlIjoxfQ.3Okb2lxU2zvPAfyK9TyOgtJiuL_ZHYu2VwJ6KZRjgzRsCBAGPutVCKumxM5dPMlfyjWXzVDSAiq3598jrBMulw'

    response = HTTParty.post('https://ecigmafia.com/graphql', body: { query: graphql_query }.to_json, headers: { 'Authorization' => authorization_token })

    data = JSON.parse(response.body)

    if data['data'] && data['data']['site']['products']['edges'].present?
      product_data = data['data']['site']['products']['edges'].first['node']

      @product_price = product_data['prices']['price']['value']

      flash[:notice] = 'Product price fetched successfully.'
    else
      flash[:alert] = 'No product data found for this entity ID.'
    end

    render 'product_price_page'
  rescue StandardError => e
    flash[:alert] = "Error fetching product price: #{e.message}"
    render 'product_price_page'
  end
end

# ... other actions ...
