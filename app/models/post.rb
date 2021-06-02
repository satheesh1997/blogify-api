class Post < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :image, format: { with: URI::regexp(%w[http https]) }

  belongs_to :user

  before_save :default_values

  enum post_status: [:draft, :published, :archieved]

  def default_values
    self.status ||= "draft"
  end
end
