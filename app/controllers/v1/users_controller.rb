class V1::UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :set_user, except: %i[create index]

  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors },
              status: :unprocessable_entity
    end
  end

  # GET /users/{username}
  def show
    render json: @user, status: :ok
  end

  # PUT /users/{username}
  def update
    unless @user.update(user_params)
      render json: { errors: @user.errors },
        status: :unprocessable_entity
    end
  end

  private
  
  def set_user
    @user = User.find_by_username!(params[:_username])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'User not found' }, status: :not_found
  end

  def user_params
    params.permit(:name, :username, :email, :password, :password_confirmation)
  end
  
end
