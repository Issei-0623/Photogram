Rails.application.routes.draw do
  get "users/show"
  devise_for :users
  root to: "home#index"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  get "up" => "rails/health#show", as: :rails_health_check
  
  resources :posts, only: [:index, :new, :create, :show] do
    resource :like, only: [:create, :destroy]
    resources :comments, only: [:create]
  end

  resources :users, only: [:show, :update]
  resources :relationships, only: [:create, :destroy]
end
