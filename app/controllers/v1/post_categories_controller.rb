# frozen_string_literal: true

class V1::PostCategoriesController < ApplicationController
  before_action :authorize_request
  before_action :can_add_category_to_post, only: %i[create]
  before_action :set_post, only: %i[show destroy]
  before_action :author?, only: %i[destroy]

  # POST /post_categories/
  def create
    new_obj = PostCategory.new(post_category_params)
    if new_obj.save
      render json: new_obj, status: :ok
    else
      render json: new_obj.errors, status: :unprocessable_entity
    end
  end

  # GET /post_categories/{_post_id}/
  def show
    render json: @post.categories, status: :ok
  end

  # DELETE /post_categories/{_post_id}/?category_id=<category_id>
  def destroy
    if params[:category_id]
      post_categories = @post.post_categories.where(category_id: params[:category_id])
    else
      post_categories = @post.post_categories
    end
    post_categories.destroy_all
    render json: {}, status: :no_content
  end

  private
    def can_add_category_to_post
      post = Post.find_by_id!(post_category_params[:post_id])
      if post.user_id != @current_user.id
        render json: { errors: "Action not allowed" }, status: :forbidden
      end
    rescue ActiveRecord::RecordNotFound
      render json: { errors: "Post not found" }, status: :not_found
    end

    def set_post
      @post = Post.find_by_id!(params[:_post_id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: "Post not found" }, status: :not_found
    end

    def author?
      unless @post.user_id == @current_user.id
        render json: { errors: "You are not the author of this post to perform this action" },
          status: :precondition_failed
      end
    end

    def post_category_params
      params.permit(:post_id, :category_id)
    end
end
