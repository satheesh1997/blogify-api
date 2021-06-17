# frozen_string_literal: true

class PostCommentLike < ApplicationRecord
  belongs_to :post_comment
  belongs_to :user
end
