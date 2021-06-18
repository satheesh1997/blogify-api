# frozen_string_literal: true

class CreatePostUserActions < ActiveRecord::Migration[6.1]
  def change
    create_table :post_user_actions do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :action

      t.timestamps
    end
    add_index :post_user_actions, :action
    add_index :post_user_actions, %i[post_id action]
    add_index :post_user_actions, %i[post_id user_id action], unique: true
  end
end
