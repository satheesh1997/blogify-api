# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "service#index"

  # auth endpoints
  post "/auth/login", to: "authentication#login"
  get "/auth/me", to: "authentication#me"

  # version 1 endpoints
  namespace :v1 do
    resources :users, param: :_username
    resources :categories, param: :_id do
      member do
        get "verify"
      end
    end
    resources :posts, param: :_id do
      member do
        get "publish"
      end
    end
    resources :post_user_actions, param: :_post_id
    resources :post_comments, param: :_id
    resources :post_comment_likes, param: :_post_comment_id
    resources :post_categories, param: :_post_id

    # public end points
    get "/:_username/:_slug/", to: "public#get_user_post"
  end
end
