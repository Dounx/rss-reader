Rails.application.routes.draw do
  root to: "home#index"
  resources :feeds
  resources :items, only: [:index, :show, :destroy]
  resources :comments, only: [:show, :create, :destroy]

  devise_for :users, controllers: { sessions:'users/sessions' }, path: '', path_names: { sign_in: 'login', sign_out: 'logout' }
  require 'sidekiq/web'
  require 'sidekiq/cron/web'

  mount Sidekiq::Web => '/sidekiq'
end
