Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  root   'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users do
    member do     #users/user_id/followingとかになる       memberじゃなくて collectionやったらidで区別しない
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]#user認証（リンクを踏むだけやからeditで！）
  resources :password_resets,     only: [:new, :create, :edit, :update]#PW再設定
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end