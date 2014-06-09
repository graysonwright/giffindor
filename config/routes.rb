Giffindor::Application.routes.draw do
  resources :gif_posts
  resources :favorites, only: [:show, :create, :destroy]

  get 'users/sign_up', to: 'users#new', as: 'signup'
  get 'users/login', to: 'sessions#new', as: 'login'
  delete 'users/logout', to: 'sessions#destroy', as: 'logout'
  resources :users, only: [:new, :create]
  resources :sessions, only: [:create, :new, :destroy]

  get "home/index"
  root 'gif_posts#index'
end
