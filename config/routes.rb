Rails.application.routes.draw do
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users, :except => :edit
  post '/guest', to: 'sessions#guest'
  root to: 'rooms#index'
  resources :rooms
end
