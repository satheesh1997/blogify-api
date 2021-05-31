Rails.application.routes.draw do
  resources :users, param: :_username
  post '/auth/login', to: 'authentication#login'
  get '/auth/me', to: 'authentication#me'

  namespace :api do
    namespace :v1 do
      resources :posts, param: :_id
    end
  end

end
