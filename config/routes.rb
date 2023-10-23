Rails.application.routes.draw do
  #resources :products
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  #get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  get '/product_price', to: 'products#product_price_page'
  post '/product_price', to: 'products#fetch_product_price'

  
  # resources :products do
  #   member do
  #     get 'fetch'
  #   end
  # end
end 
