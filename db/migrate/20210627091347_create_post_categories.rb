class CreatePostCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :post_categories do |t|
      t.references :post, null: false, foreign_key: true
      t.references :catetory, null: false, foreign_key: true

      t.timestamps
    end
    add_index :post_categories, %i[post_id category_id], unique: true
  end
end
