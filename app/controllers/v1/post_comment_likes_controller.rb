# frozen_string_literal: true

module V1
  class PostCommentLikesController < ApplicationController
    before_action :authorize_request
    before_action :set_post_comment, only: [:show]

    def index
      render json: @current_user.post_comment_likes.as_json(
        include: { post_comment: { only: [:id, :post_id, :content] } },
        except: [:user_id, :post_comment_id]),
            status: :ok
    end

    def create
      post_comment_like = PostCommentLike.new(
        post_comment_id: params[:post_comment_id],
        user_id: @current_user.id
      )
      if post_comment_like.save
        render json: post_comment_like, status: :created
      else
        render json: { errors: post_comment_like.errors }, status: :unprocessable_entity
      end
    end

    def show
      render json: @post_comment.post_comment_likes.as_json(
        include: { user: { only: [:name, :id] } },
        except: [:user_id, :post_comment_id]),
            status: :ok
    end

    private
      def set_post_comment
        @post_comment = PostComment.find_by_id!(params[:_post_comment_id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: "Post comment not found" }, status: :not_found
      end

      def post_comment_like_params
        params.permit(:post_comment_id)
      end
  end
end
