Rails.application.routes.draw do
  root "homes#index"
  resources :users, only: %i[new create]
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"
  resources :rules, only: %i[index]
  resources :games, only: [ :new ] do
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
end
