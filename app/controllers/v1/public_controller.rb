class V1::PublicController < ApplicationController
  before_action :set_user, only: [:get_user_post]

  def get_user_post
    @post = @user.posts.find_by_slug!(params[:_slug])
    render json: @post, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Post not found' }, status: :not_found
  end

  private

  def set_user
    @user = User.find_by_username!(params[:_username])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'User not found' }, status: :not_found
  end
end
