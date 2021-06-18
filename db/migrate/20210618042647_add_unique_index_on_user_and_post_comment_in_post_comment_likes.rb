class AddUniqueIndexOnUserAndPostCommentInPostCommentLikes < ActiveRecord::Migration[6.1]
  def change
    add_index :post_comment_likes, [:post_comment, :user], unique:true
  end
end
