class Api::V1::PostsController < ApplicationController
  before_action :authorize_request
  before_action :set_post, except: %i[create index]

  # GET /posts
  def index
    @posts = @current_user.posts.all
    render json: @posts, status: :ok
  end

  # GET /posts/{id}
  def show
    render json: @post, status: :ok
  end

  # POST /posts
  def create
    @post = @current_user.posts.new(post_params)
    if @post.save
      render json: @post, status: :created
    else
      render json: { erros: @post.errors },
              status: :unprocessable_entity
    end
  end

  # PUT /posts/{id}
  def update
    if @post.update(post_params)
      render json: @post, status: :ok
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

  private

  def set_post
    @post = @current_user.posts.find_by_id!(params[:_id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'Post not found' }, status: :not_found
  end

  def post_params
    params.permit(:title, :content, :image)
  end

end
