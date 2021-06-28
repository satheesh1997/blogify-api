class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :verbose
      t.string :slug
      t.boolean :is_visible

      t.timestamps
    end
    add_index :categories, :is_visible
    add_index :categories, %i[verbose slug], unique: true
  end
end
