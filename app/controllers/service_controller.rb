# frozen_string_literal: true

class ServiceController < ApplicationController
  def index
    render json: { status: "OK" }, status: :ok
  end
end
