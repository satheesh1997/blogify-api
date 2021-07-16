# frozen_string_literal: true

class PostCategory < ApplicationRecord
  validates :category, uniqueness: { scope: :post }

  belongs_to :post
  belongs_to :category
end
