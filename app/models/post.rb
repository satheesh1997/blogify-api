class Post < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :image, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }

  belongs_to :user
  has_many :post_user_actions

  before_save :auto_generate_fields

  enum post_status: %i[draft published archieved]

  def meta
    {
      'likes': post_user_actions.where(action: PostUserAction::ACTIONS[:like]).count,
      'dislikes': post_user_actions.where(action: PostUserAction::ACTIONS[:dislike]).count
    }
  end

  def auto_generate_fields
    self.status ||= 'draft'
    self.excerpt = ActionController::Base.helpers.strip_tags(content.truncate(200)) if content
    if title && (self.status == :draft.to_s)
      self.slug = title.parameterize.truncate(100) # max length of slug is 100
    end
  end

  def as_json(options = {})
    super(options.merge({ except: [:post_status], methods: [:meta] }))
  end
end
