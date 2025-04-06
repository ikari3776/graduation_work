Rails.application.routes.draw do
  root "homes#index"
  resources :users, only: %i[new create edit update]
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"
  resources :rules, only: %i[index]
  resources :ranks, only: %i[index]
  resources :password_resets, only: %i[new create edit update]
  resources :policy, only: %i[index]
  resources :terms, only: %i[index]
  resources :games, only: %i[index] do
    collection do
      get :search, as: 'search'
      get :result, as: 'result'
    end
  end
  get "games/reset_session", to: "games#reset_game_session"
  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback" 
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider
  get '/name/new', to: 'users#new_name', as: 'new_name'
  patch '/name', to: 'users#create_name', as: 'create_name'
  resources :contacts, only: %i[new create] do
    collection do
      post 'confirm'
      post 'back'
      get 'done'
    end
  end
end
