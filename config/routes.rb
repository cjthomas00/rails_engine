Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      get '/merchants/find_all', to: "merchant/search#index"
      
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: "items"
      end


      resources :items do
        resources :merchant, to: "merchants#show"
      end
    end
  end
end
