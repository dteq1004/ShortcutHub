Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :users, param: :uid, only: [ :show, :edit, :update, :destroy ] do
    member do
      get "followings", to: "relationships#followings"
      get "followers", to: "relationships#followers"
    end
  end
  post "users/:id/relationships", to: "relationships#create", as: :relationships
  delete "users/:id/relationships", to: "relationships#destroy"
  get "mypage" => "users#mypage"
  resources :shortcuts do
    member do
      get :archived
    end
  end
  get "shortcut/index_lazy", to: "shortcuts#index_lazy"
  get "tags/search" => "shortcuts#search"
  resources :official_shortcuts, only: [ :index, :show ]
  resources :news, only: [ :index, :show ]
  get "search", to: "searches#search"
  get "search/index", to: "searches#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "homes#index"
end
