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
  resources :rooms, except: [:index] do
    resources :reservations, only: [:create, :destroy]
    collection do
      post :confirm
    end
  end

  # チャット
  get '/chats', to: 'chats#show'
end
