class CreatePostCommentLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :post_comment_likes do |t|
      t.references :post_comment, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
