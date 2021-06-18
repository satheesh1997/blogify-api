# frozen_string_literal: true

module V1
  class PostCommentLikesController < ApplicationController
    before_action :authorize_request
    before_action :set_post_comment, only: [:show]

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
    rescue ActiveRecord::RecordNotUnique
      render json: { errors: "You have already liked this post comment" }, status: :precondition_failed
    end

    def show
      render json @post_comment.post_comment_likes, status: :o
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
