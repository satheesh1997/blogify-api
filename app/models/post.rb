# frozen_string_literal: true

class Post < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :image, presence: true

  belongs_to :user

  has_many :post_categories, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :post_user_actions, dependent: :destroy

  has_many :categories, through: :post_categories

  has_one_attached :image

  before_save :auto_generate_fields

  enum post_status: { draft: 0, published: 1, archieved: 2 }

  def meta
    {
      likes: post_user_actions.where(action: PostUserAction::ACTIONS[:like]).count,
      dislikes: post_user_actions.where(action: PostUserAction::ACTIONS[:dislike]).count,
      image: self.get_image_info()
    }
  end

  def auto_generate_fields
    self.status ||= "draft"
    self.excerpt = ActionController::Base.helpers.strip_tags(content.truncate(200)) if content
    if title && (self.status == :draft.to_s)
      self.slug = title.parameterize.truncate(100) # max length of slug is 100
    end
  end

  private
    def get_image_info
      if self.image.attached?
        self.image.analyze
        {
          url: Rails.application.routes.url_helpers.rails_blob_path(self.image, only_path: true),
          metadata: self.image.metadata
        }
      end
    end
end
