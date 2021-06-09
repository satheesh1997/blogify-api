Rails.application.routes.draw do
  post '/auth/login', to: 'authentication#login'
  get '/auth/me', to: 'authentication#me'
  
  namespace :v1 do
    resources :users, param: :_username
    resources :posts, param: :_id
  end

end
