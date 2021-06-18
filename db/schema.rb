# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_18_042647) do

  create_table "post_comment_likes", force: :cascade do |t|
    t.integer "post_comment_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "\"post_comment\", \"user\"", name: "index_post_comment_likes_on_post_comment_and_user", unique: true
    t.index ["post_comment_id"], name: "index_post_comment_likes_on_post_comment_id"
    t.index ["user_id"], name: "index_post_comment_likes_on_user_id"
  end

  create_table "post_comments", force: :cascade do |t|
    t.integer "post_id"
    t.integer "user_id"
    t.string "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "\"post\"", name: "index_post_comments_on_post"
    t.index "\"post\", \"user\"", name: "index_post_comments_on_post_and_user"
    t.index ["post_id"], name: "index_post_comments_on_post_id"
    t.index ["user_id"], name: "index_post_comments_on_user_id"
  end

  create_table "post_user_actions", force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "user_id", null: false
    t.integer "action"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "\"post\", \"action\"", name: "index_post_user_actions_on_post_and_action"
    t.index "\"post\", \"user\", \"action\"", name: "index_post_user_actions_on_post_and_user_and_action", unique: true
    t.index ["action"], name: "index_post_user_actions_on_action"
    t.index ["post_id"], name: "index_post_user_actions_on_post_id"
    t.index ["user_id"], name: "index_post_user_actions_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.string "excerpt"
    t.string "image"
    t.integer "user_id", null: false
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug", limit: 100
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "post_comment_likes", "post_comments"
  add_foreign_key "post_comment_likes", "users"
  add_foreign_key "post_user_actions", "posts"
  add_foreign_key "post_user_actions", "users"
  add_foreign_key "posts", "users"
end
