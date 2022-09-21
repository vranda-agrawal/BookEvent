require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root "home#index"
  resources :events
  devise_for :users
  resources :customers, :controller => "users"
  get "/home" , to: 'home#index'
  get '/user', to: 'home#index'
  post '/payment/:id', to: 'payment#create',as: :payments
  get '/register/:id',to: 'events#register', as: :register
  mount Sidekiq::Web => '/sidekiq'

end
