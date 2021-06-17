# frozen_string_literal: true

module V1
  class PublicController < ApplicationController
    before_action :set_user, only: [:get_user_post]

    def get_user_post
      @post = @user.posts.find_by!(slug: params[:_slug])
      render json: @post, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { errors: "Post not found" }, status: :not_found
    end

    private
      def set_user
        @user = User.find_by!(username: params[:_username])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: "User not found" }, status: :not_found
      end
  end
end
