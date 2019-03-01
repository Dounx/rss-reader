Rails.application.routes.draw do
  devise_for :users
  root to: "feeds#index"
  resources :feeds
  resources :items
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
