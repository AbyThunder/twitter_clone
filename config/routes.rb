Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  resources :users, only: [:index, :show, :new, :create]
  resources :tweets, only: [:index, :show]

  namespace :api do
    resources :users, only: %i[index show create update destroy] do # == [:index, :show]
      resource :followings, only: %i[show create destroy]
    end
    resources :tweets, only: %i[index show create update destroy] do
      resource :like, only: %i[create destroy]
=begin
  def destroy
    like = Like.find_by(user_id: params[:user_id], tweet_id: params[:tweet_id])
    like.destroy
    render json: like
  end
=end
    end
  end
end
