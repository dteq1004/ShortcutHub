Rails.application.routes.draw do
  get "terms_of_use", to: "static_pages#terms_of_use"
  get "privacypolicy", to: "static_pages#privacypolicy"
  get "guideline", to: "static_pages#guideline"
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks",
    passwords: "users/passwords",
  }
  devise_scope :user do
    post "resend_confirmation", to: "users/registrations#resend_confirmation", as: :resend_confirmation
  end
  resources :users, param: :uid, only: %i[ show edit update destroy ] do
    get "show_lazy", to: "users#show_lazy"
    member do
      get "followings", to: "relationships#followings"
      get "followers", to: "relationships#followers"
    end
  end
  post "users/:id/relationships", to: "relationships#create", as: :relationships
  delete "users/:id/relationships", to: "relationships#destroy"
  get "user/email", to: "users#email"
  post "user/email", to: "users#email_change"
  get "user/confirm", to: "users#confirm"
  get "mypage", to: "users#mypage"
  get "mypage_lazy", to: "users#mypage_lazy"
  get "bookmarks", to: "users#bookmarks"
  get "bookmarks_lazy", to: "users#bookmarks_lazy"
  get "analytics", to: "users#analytics"
  get "analytics_lazy", to: "users#analytics_lazy"
  get "home/latest_shortcuts", to: "homes#latest_shortcuts"
  get "home/popular_shortcuts", to: "homes#popular_shortcuts"
  get "home/user_ranking", to: "homes#user_ranking"
  get "home/news", to: "homes#news"
  resources :shortcuts do
    member do
      get :archived
    end
    resources :comments, only: %i[ show create edit update destroy ]
  end
  post "shortcuts/generate_thumbnail", to: "shortcuts#generate_thumbnail"
  get "shortcut/index_lazy", to: "shortcuts#index_lazy"
  get "tags/search" => "shortcuts#search"
  resources :official_shortcuts, only: %i[ index show ]
  resources :news, only: %i[ index show ]
  get "search", to: "searches#search"
  get "search/index", to: "searches#index"
  get "autocomplete", to: "searches#autocomplete"
  get "follow", to: "follows#index"
  get "follow/index_lazy", to: "follows#index_lazy"
  resources :favorites, only: %i[ create destroy ]
  resources :bookmarks, only: %i[ create destroy ]
  resources :notifications, only: :index
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "homes#index"
  get "*path", to: "application#render404", constraints: lambda {
    |req| !req.path.start_with?("/rails/active_storage")
  }
end
