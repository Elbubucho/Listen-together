Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  get "up" => "rails/health#show", as: :rails_health_check
  # Defines the root path route ("/")
  root "posts#index"
  resources :posts do
    resources :reactions, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end

  resources :users do
    member do
      get :friends
      get :friend_requests_sent
      get :friend_requests_received
    end
  end


  resources :users, only: [:show, :edit, :update]

  resources :friendships, only: [:create, :update, :destroy]

  get 'tracks/autocomplete', to: 'posts#autocomplete'
end
