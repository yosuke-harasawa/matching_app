Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  root   'users#index'
  get    '/signup',   to: 'users#new'
  post   '/signup',   to: 'users#create'
  get    '/login',    to: 'sessions#new'
  post   '/login',    to: 'sessions#create'
  delete '/logout',   to: 'sessions#destroy'
  get    '/show_additionally', to: 'rooms#show_additionally'
  
  resources :users do
    member do
      get :following, :followers, :matchers
    end
  end  
  resources :account_activations, only: :edit
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :relationships,       only: :create
  resources :rooms,               only: [:show, :create]
  resources :messages,            only: :create
end
