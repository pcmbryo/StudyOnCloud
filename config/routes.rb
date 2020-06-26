Rails.application.routes.draw do
  # ルート
  root to: 'rooms#index'

  # ログイン
  get '/login',   to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  post '/login/guest', to: 'sessions#guest'
  delete '/logout',  to: 'sessions#destroy'

  # ユーザー
  resources :users, except: [:index, :edit, :delete]

  # 勉強会
  resources :rooms, except: [:index]
  post '/rooms/confirm', to: 'rooms#confirm'
  post '/rooms/reservate/:id', to: 'rooms#reservate'

  # チャット
  get '/rooms/:id/chats', to: 'chats#show'
end
