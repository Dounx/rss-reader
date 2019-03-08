Rails.application.routes.draw do
  namespace :admin do
      resources :users
      resources :comments
      resources :feeds
      resources :items
      resources :item_states
      resources :recommended_feeds
      resources :subscriptions

      root to: "users#index"
    end
  root to: "home#index"
  resources :feeds
  resources :items, only: [:index, :show, :destroy]
  resources :comments, only: [:show, :create, :destroy]
  resources :recommended_feeds, only: [:index, :create]
  resources :users, only: [:show, :edit, :update]
  get '/search', to: 'search#index'

  devise_for :users, controllers: { sessions:'users/sessions' }, path: '', path_names: { sign_in: 'login', sign_out: 'logout' }
  require 'sidekiq/web'
  require 'sidekiq/cron/web'

  mount Sidekiq::Web => '/sidekiq'
end
