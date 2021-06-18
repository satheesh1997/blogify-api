# frozen_string_literal: true

class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  has_many :post_comment_likes, dependent: :destroy
end
