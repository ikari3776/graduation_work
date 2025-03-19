Rails.application.routes.draw do
  root "homes#index"
  resources :users, only: %i[new create edit update]
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"
  get "admin/infos", to: "infos#index"
  resources :rules, only: %i[index]
  resources :ranks, only: %i[index]
  resources :password_resets, only: %i[new create edit update]
  resources :games, only: %i[new] do
    collection do
      get "result/:game_id", to: "games#result", as: "result"
    end

    resources :questions, only: [ :show ], param: :number do
      collection do
        post "answer"
        get "result/:number", to: "questions#result", as: "result"
      end
    end
  end
  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback" 
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider
  get '/name/new', to: 'users#new_name', as: 'new_name'
  patch '/name', to: 'users#create_name', as: 'create_name'
end
