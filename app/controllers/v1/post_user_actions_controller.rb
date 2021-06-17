# frozen_string_literal: true

module V1
  class PostUserActionsController < ApplicationController
    before_action :authorize_request
    before_action :set_post, except: %i[create index]
    before_action :validate_user_action, only: [:create]

    def index
      render json: @current_user.post_user_actions, status: :ok
    end

    def create
      begin
        @post = Post.find(params[:post_id])
      rescue ActiveRecord::RecordNotFound
        return render json: {
          errors: { post_id: "Post not found" }
        }, status: :not_found
      end

      if @current_user == @post.user
        render json: {
          errors: "Author cannot perform this action"
        }, status: :precondition_failed
      elsif @current_user.post_user_actions
                         .where(
                           post_id: params[:post_id],
                           action: @current_user_action
                         ).present?
        render json: {
          errors: "You have already performed this action"
        }, status: :precondition_failed
      else
        @current_user.post_user_actions
                     .where(user: @current_user)
                     .destroy_all
        post_user_action = @current_user.post_user_actions.new(
          post: @post,
          action: @current_user_action
        )
        if post_user_action.save
          render json: post_user_action, status: :ok
        else
          render json: {
            errors: post_user_action.errors
          }, status: :unprocessable_entity
        end
      end
    end

    private
      def set_post
        @post = Post.find(params[:_post_id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: "Post not found" }, status: :not_found
      end

      def validate_user_action
        if !params[:user_action] || !PostUserAction::ACTIONS.key?(params[:user_action].to_sym)
          render json: {
            errors: { user_action: "invalid action" }
          }, status: :unprocessable_entity
        else
          @current_user_action = PostUserAction::ACTIONS[
            params[:user_action].to_sym
          ]
        end
      end

      def post_user_action_params
        params.permit(:post_id, :action)
      end
  end
end
