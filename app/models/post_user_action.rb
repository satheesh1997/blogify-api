# frozen_string_literal: true

class PostUserAction < ApplicationRecord
  belongs_to :post
  belongs_to :user

  ACTIONS = {
    like: 0,
    dislike: 1
  }.freeze
end
