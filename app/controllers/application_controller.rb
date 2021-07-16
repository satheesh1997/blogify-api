# frozen_string_literal: true

class ApplicationController < ActionController::API
  def authorize_request
    header = request.headers["Authorization"]
    header = header.split.last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def owner?
    unless @current_user.id == 1
      render json: { errors: "Only the app owner is allowed to perform this action" }, status: :forbidden
    end
  end
end
