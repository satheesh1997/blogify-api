# frozen_string_literal: true

class Category < ApplicationRecord
  validates :verbose, presence: true, length: { minimum: 2, maximum: 50 }

  before_save :auto_generate_fields

  def auto_generate_fields
    self.slug = verbose.parameterize
    self.is_visible ||= false
  end
end
