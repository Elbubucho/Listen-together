Rails.application.routes.draw do
  get 'searches/index'
  get 'rooms/index'
  devise_for :users, controllers: { registrations: "users/registrations" }

  get "up" => "rails/health#show", as: :rails_health_check
  # Defines the root path route ("/")
  root "posts#index"
  resources :posts do
    resources :reactions, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end

  resources :users do
    get :edit_profile
    patch :update_profile
    member do
      get :friends
      get :friend_requests_sent
      get :friend_requests_received
    end
  end

  resources :rooms do
    resources :messages
  end

  resources :notifications, only: [:index, :update, :destroy]

  resources :users, only: [:show, :edit, :update]

  resources :friendships, only: [:create, :update, :destroy]

  get 'tracks/autocomplete', to: 'posts#autocomplete'
  get 'users/:id/chat', to: 'users#chat', as: :chat
  get "/search", to: "searches#index", as: :search
end
