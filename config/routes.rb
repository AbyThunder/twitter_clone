Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"

  resources :users, only: [:index, :show, :new, :create]
  resources :tweets, only: [:index, :show]

  namespace :api do
    resources :users, only: %i[index show create update destroy] do 
      resource :followings, only: %i[show create destroy]
    end
    resources :tweets, only: %i[index show create update destroy] do
      resource :like, only: %i[create destroy]
    end

    post '/auth/login', to: 'authentication#login'
  end

  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
end
