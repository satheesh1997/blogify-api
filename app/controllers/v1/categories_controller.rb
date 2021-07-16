# frozen_string_literal: true

class V1::CategoriesController < ApplicationController
  before_action :authorize_request
  before_action :owner?, except: %i[create index show]
  before_action :set_category, except: %i[create index]

  # GET /categories
  def index
    render json: Category.all, status: :ok
  end

  # GET /categories/{id}
  def show
    render json: @category, status: :ok
  end

  # POST /categories
  def create
    category = Category.new(category_params)
    category.is_visible = @current_user.owner?
    if category.save
      render json: category, status: :created
    else
      render json: { errors: category.errors },
             status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    render json: { errors: { verbose: ["already exists"] } }, status: :unprocessable_entity
  end

  # PUT /categories/{id}
  def update
    if @category.update(category_params)
      render json: @category, status: :ok
    else
      render json: { errors: @category.errors }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    render json: { errors: { verbose: ["already exists"] } }, status: :unprocessable_entity
  end

  # DELETE /categories/{id}
  def destroy
    @category.destroy
    render json: {}, status: :no_content
  end

  private
    def set_category
      @category = Category.find_by_id!(params[:_id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: "Category not found" }, status: :not_found
    end

    def category_params
      params.permit(:verbose)
    end
end
