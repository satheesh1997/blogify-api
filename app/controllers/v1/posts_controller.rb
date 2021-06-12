class V1::PostsController < ApplicationController
  before_action :authorize_request
  before_action :set_post, except: %i[create index]
  before_action :is_not_author, only: [:like]

  # GET /posts
  def index
    if params[:status] == "all" or !params[:status]
      @posts = @current_user.posts.all
    else
      @posts = @current_user.posts.where({status: params[:status]})
    end
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

  # GET /posts/{id}/publish
  def publish
    if @post.status == :published.to_s
      render json: @post, status: :not_modified
    else
      if @post.update(status: :published.to_s)
        render json: @post, status: :ok
      else
        render json: {errors: @post.errors },
                status: :unprocessable_entity
      end
    end
  end

  # GET /posts/{id}/like/
  def like
    if @post.post_user_actions
        .where(user: @current_user)
        .where(action: PostUserAction::ACTIONS[:like])
        .present?
      render json: {
        errors: 'You have already performed this action'
      }, status: :precondition_failed
    else
      # delete old actions if any present for this user
      @post.post_user_actions.destroy_all(user: @current_user)
      # create a new like action record from this user
      @post.post_user_actions.create(
        user: @current_user, action: PostUserAction::ACTIONS[:like])
      render json: { message: 'Action success' }, status: :ok
    end
  end

  private

  def set_post
    @post = @current_user.posts.find_by_id!(params[:_id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'Post not found' }, status: :not_found
  end

  def is_not_author
    if @current_user == @post.user
      render json: { errors: 'Author cannot perform this action' }, status: :precondition_failed
    end
  end

  def post_params
    params.permit(:title, :content, :image)
  end

end
