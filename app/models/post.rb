class Post < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :image, format: { with: URI::regexp(%w[http https]) }

  belongs_to :user

  before_save :auto_generate_fields

  enum post_status: [:draft, :published, :archieved]

  def auto_generate_fields
    self.status ||= "draft"
    if self.content
      self.excerpt = ActionController::Base.helpers.strip_tags(self.content.truncate(200))
    end
    if self.title and self.status == :draft.to_s
      self.slug = self.title.parameterize.truncate(100) # max length of slug is 100
    end
  end

  def as_json(options={})
    super(options.merge({ except: [:post_status] }))
  end
end
