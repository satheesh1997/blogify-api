Rails.application.routes.draw do
  resources :users, param: :_username
  post '/auth/login', to: 'authentication#login'

  namespace :api do
    namespace :v1 do
      resources :posts, param: :_id
    end
  end

end
