# frozen_string_literal: true

class V1::PostCategoriesController < ApplicationController
  before_action :authorize_request
  before_action :can_add_category_to_post, only: %[create]
  before_action :is_post_owner, only: %[destroy]

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
    categories = PostCategory.where(post_id: params[:_post_id])
    render json: categories.as_json(
      include: { category: { only: [:verbose, :slug ] } },
      except: [:post_id, :id, :updated_at]
    ), status: :ok
  end

  # DELETE /post_categories/{_post_id}/?category_id=<category_id>
  def destroy
    if params[:category_id]
      post_categories = PostCategory.where(
        post_id: params[:_post_id],
        category_id: params[:category_id]
      )
      if not post_categories.exists?
        return render json: { errors: "Post doesn't belong to the given category" }, status: :not_found
      end
    else
      post_categories = PostCategory.where(post_id: params[:_post_id])
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
    def is_post_owner
      post = Post.find_by_id!(params[:_post_id])
      if post.user_id != @current_user.id
        render json: { errors: "Action not allowed" }, status: :forbidden
      end
    rescue ActiveRecord::RecordNotFound
      render json: { errors: "Post not found" }, status: :not_found
    end
    def post_category_params
      params.permit(:post_id, :category_id)
    end
end
