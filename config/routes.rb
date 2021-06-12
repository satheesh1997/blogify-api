Rails.application.routes.draw do
  post '/auth/login', to: 'authentication#login'
  get '/auth/me', to: 'authentication#me'
  
  namespace :v1 do
    resources :users, param: :_username
    resources :posts, param: :_id
    get 'posts/:_id/publish/', to: 'posts#publish'

    # public end points
    get '/:_username/:_slug/', to: 'public#get_user_post'
  end

end
