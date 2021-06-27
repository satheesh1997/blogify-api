# frozen_string_literal: true

class ServiceController < ApplicationController
  def index
    render json: get_index_response(),
           status: :ok
  end

  private
    def get_index_response
      {
        status: "OK",
        api: {
          current: "v1",
          supported: [ "v1" ],
          docs: "https://documenter.getpostman.com/view/16280044/Tzef92vE"
        }
      }
    end
end
