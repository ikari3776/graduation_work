Rails.application.routes.draw do
  root "homes#index"
  resources :users, only: %i[new create]
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"
  resources :rules, only: %i[index]
  resources :games, only: %i[index]
end
