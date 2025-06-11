Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  root "posts#index"
  resources :posts do
    resources :comments, only: [:create, :destroy]
    resource :reaction, only: [:create, :destroy]
  end
  
   get 'tracks/autocomplete', to: 'posts#autocomplete'
  
end