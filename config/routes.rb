Rails.application.routes.draw do
  devise_for :users
  root to: "posts#index"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  get "up" => "rails/health#show", as: :rails_health_check
  
  resources :posts, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
    resource :like, only: [:create, :destroy]
    resources :comments, only: [:create]
  end

  resources :users, only: %i[show update] do
    member do
      get :following
      get :followers
    end
  end

  resources :relationships, only: [:create, :destroy]
end
