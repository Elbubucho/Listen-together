Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  root "posts#index"
  resources :posts, only: [:show]
end
