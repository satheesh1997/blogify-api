class Post < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :image, format: { with: URI::regexp(%w[http https]) }

  belongs_to :user
end
