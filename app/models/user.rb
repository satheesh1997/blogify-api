# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }

  has_many :posts
  has_many :post_comments, dependent: :destroy
  has_many :post_comment_likes, dependent: :destroy
  has_many :post_user_actions, dependent: :destroy

  def as_json(options = {})
    super(options.merge({ except: [:password_digest] }))
  end
end
