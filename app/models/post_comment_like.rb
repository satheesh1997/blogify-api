# frozen_string_literal: true

class PostCommentLike < ApplicationRecord
  validates :post_comment, uniqueness: { scope: :user, message: "is already been liked" }

  belongs_to :post_comment
  belongs_to :user
end
