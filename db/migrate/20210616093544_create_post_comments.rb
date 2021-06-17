# frozen_string_literal: true

class CreatePostComments < ActiveRecord::Migration[6.1]
  def change
    create_table :post_comments do |t|
      t.references :post
      t.references :user
      t.string :content

      t.timestamps
    end
    add_index :post_comments, :post
    add_index :post_comments, %i[post user]
  end
end
