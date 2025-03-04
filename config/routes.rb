Rails.application.routes.draw do
  root "homes#index"
  resources :users, only: %i[new create]
end
