# frozen_string_literal: true

module V1
  class PostsController < ApplicationController
    before_action :authorize_request
    before_action :set_post, except: %i[create index]

    # GET /posts
    def index
      @posts = if (params[:status] == "all") || !params[:status]
        @current_user.posts.all
      else
        @current_user.posts.where({ status: params[:status] })
      end
      render json: @posts.as_json(
        include: { categories: {} },
        except: [:user_id, :post_status],
        methods: [:meta]),
            status: :ok
    end

    # GET /posts/{id}
    def show
      render json: @post.as_json(
        include: { user: { only: [:name, :id] }, categories: {} },
        except: [:user_id, :post_status],
        methods: [:meta]),
             status: :ok
    end

    # POST /posts
    def create
      @post = @current_user.posts.new(post_params)
      if @post.save
        render json: @post, status: :created
      else
        render json: { errors: @post.errors },
               status: :unprocessable_entity
      end
    end

    # PUT /posts/{id}
    def update
      if @post.update(post_params)
        render json: @post.as_json(
          include: {},
          except: [:user_id, :post_status],
          methods: [:meta]),
               status: :ok

      else
        render json: { errors: @post.errors },
               status: :unprocessable_entity
      end
    end

    # DELETE /posts/{id}
    def destroy
      @post.destroy
      render json: {}, status: :no_content
    end

    # GET /posts/{id}/publish
    def publish
      if @post.status == :published.to_s
        render json: { message: "Post already published" }, status: :not_modified
      elsif @post.update(status: :published.to_s)
        render json: { messae: "Post published successfully" }, status: :ok
      else
        render json: { errors: @post.errors },
               status: :unprocessable_entity
      end
    end

    private
      def set_post
        @post = @current_user.posts.find(params[:_id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: "Post not found" }, status: :not_found
      end

      def post_params
        params.permit(:title, :content, :image)
      end
  end
end
