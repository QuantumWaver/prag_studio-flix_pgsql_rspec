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

ActiveRecord::Schema.define(version: 20170926191545) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "characterizations", force: :cascade do |t|
    t.bigint "movie_id"
    t.bigint "genre_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_characterizations_on_genre_id"
    t.index ["movie_id", "genre_id"], name: "index_characterizations_on_movie_id_and_genre_id", unique: true
    t.index ["movie_id"], name: "index_characterizations_on_movie_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "movie_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id", "user_id"], name: "index_favorites_on_movie_id_and_user_id", unique: true
    t.index ["movie_id"], name: "index_favorites_on_movie_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movies", force: :cascade do |t|
    t.string "title"
    t.string "rating"
    t.decimal "total_gross"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.date "released_on"
    t.string "cast"
    t.string "director"
    t.string "duration"
    t.string "image_file_name", default: ""
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "stars"
    t.text "comment"
    t.bigint "movie_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location"
    t.integer "user_id"
    t.index ["movie_id"], name: "index_reviews_on_movie_id"
    t.index ["user_id", "movie_id"], name: "index_reviews_on_user_id_and_movie_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.boolean "admin", default: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "characterizations", "genres"
  add_foreign_key "characterizations", "movies"
  add_foreign_key "favorites", "movies"
  add_foreign_key "favorites", "users"
  add_foreign_key "reviews", "movies"
end
