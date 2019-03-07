# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_03_07_102204) do

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.integer "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_comments_on_item_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "feeds", force: :cascade do |t|
    t.string "title"
    t.string "link"
    t.string "description"
    t.string "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "modified_at"
    t.index ["link"], name: "index_feeds_on_link", unique: true
  end

  create_table "item_states", force: :cascade do |t|
    t.integer "item_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_item_states_on_item_id"
    t.index ["user_id", "item_id"], name: "index_item_states_on_user_id_and_item_id", unique: true
    t.index ["user_id"], name: "index_item_states_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "title"
    t.string "link"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "feed_id"
    t.index ["feed_id"], name: "index_items_on_feed_id"
    t.index ["link"], name: "index_items_on_link", unique: true
  end

  create_table "recommended_feeds", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "feed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feed_id"], name: "index_subscriptions_on_feed_id"
    t.index ["user_id", "feed_id"], name: "index_subscriptions_on_user_id_and_feed_id", unique: true
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
