Rails.application.routes.draw do
  root to: "site#index"
  resources :feeds
  resources :items

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout' }

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
