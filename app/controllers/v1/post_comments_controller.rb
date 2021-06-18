# frozen_string_literal: true

module V1
  class PostCommentsController < ApplicationController
    before_action :authorize_request
    before_action :set_post_comment, except: %i[index create]
    before_action :author?, only: %i[update destroy]

    # GET /post_comments/ -> Get all the user comments in the posts.
    # GET /post_comments/?_post_id=? -> Get all the post comments.
    def index
      if params[:_post_id]
        post_comments = PostComment.where(post_id: params[:_post_id])
        render json: post_comments.as_json(
          include: { user: { only: [:name, :id] } },
          except: [:post_id, :user_id]),
              status: :ok
      else
        render json: @current_user.post_comments.as_json(
          include: { post: { only: [:title, :id, :excerpt] } },
          except: [:user_id, :post_id]),
              status: :ok
      end
    end

    # POST /post_comments/
    def create
      begin
        @post = Post.find(params[:post_id])
      rescue ActiveRecord::RecordNotFound
        return render json: { errors: "Post not found" }, status: :not_found
      end
      new_comment = @post.post_comments.new(
        content: params[:content],
        post_id: params[:post_id],
        user_id: @current_user.id
      )
      if new_comment.save
        render json: new_comment, status: :ok
      else
        render json: { errors: new_comment.errors }, status: :unprocessable_entity
      end
    end

    # GET /post_comments/{id}/
    def show
      render json: @post_comment.as_json(
        include: { post: { only: [:id, :title, :excerpt] }, user: { only: [:id, :name] } },
        except: [:user_id, :post_id]),
            status: :ok
    end

    # PUT /post_comments/{id}/
    def update
      unless @post_comment.update(post_comment_params)
        render json: { errors: @post_comment.errors },
               status: :unprocessable_entity
      end
    end

    # DELETE /post_comments/{id}/
    def destroy
      @post_comment.destroy
      render json: {}, status: :no_content
    end

    private
      def set_post_comment
        @post_comment = PostComment.find(params[:_id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: "Post comment not found" }, status: :not_found
      end

      def author?
        unless @post_comment.user_id == @current_user.id
          render json: { errors: "You are not the comment author to perform this action" },
                 status: :precondition_failed
        end
      end

      def post_comment_params
        params.permit(:post_id, :content)
      end
  end
end
