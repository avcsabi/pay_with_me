# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :merchants
  resources :merchants do
    resources :transactions, only: %i[index show]
  end
  resources :transactions, only: %i[index show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: 'passthrough#index'

  namespace :api, defaults: { format: :json } do
    # Merchant
    post 'get_jwt_token', to: 'merchants#get_jwt_token'

    # Transactions
    get 'transactions/authorize_transaction_count', to: 'transactions#authorize_transaction_count'
    post 'transactions/create', to: 'transactions#create'
    post 'transactions/echo', to: 'transactions#echo'
    post 'echo', to: 'transactions#echo'
  end
end
