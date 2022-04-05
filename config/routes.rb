Rails.application.routes.draw do
  resources :users, only: [:index, :show]
  resources :tweets, only: [:index, :show]
end
