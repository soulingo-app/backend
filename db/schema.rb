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

ActiveRecord::Schema[8.1].define(version: 2026_01_13_104810) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "lessons", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "lesson_id"
    t.string "lesson_type"
    t.string "level"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_lessons_on_lesson_id", unique: true
  end

  create_table "pronunciation_attempts", force: :cascade do |t|
    t.text "actual_text"
    t.datetime "created_at", null: false
    t.text "expected_text"
    t.bigint "lesson_id", null: false
    t.json "mistakes"
    t.integer "score"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["lesson_id"], name: "index_pronunciation_attempts_on_lesson_id"
    t.index ["user_id"], name: "index_pronunciation_attempts_on_user_id"
  end

  create_table "user_lessons", force: :cascade do |t|
    t.string "audio_url"
    t.datetime "created_at", null: false
    t.bigint "lesson_id", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "video_url"
    t.index ["lesson_id"], name: "index_user_lessons_on_lesson_id"
    t.index ["user_id"], name: "index_user_lessons_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "audio_file_url"
    t.datetime "created_at", null: false
    t.string "did_avatar_id"
    t.string "elevenlabs_voice_id"
    t.string "email"
    t.string "image_file_url"
    t.string "lesson_1_1_audio_url"
    t.datetime "lesson_1_1_generated_at"
    t.string "password_digest"
    t.integer "recording_duration"
    t.datetime "updated_at", null: false
    t.string "voice_cloning_status", default: "pending"
  end

  add_foreign_key "pronunciation_attempts", "lessons"
  add_foreign_key "pronunciation_attempts", "users"
  add_foreign_key "user_lessons", "lessons"
  add_foreign_key "user_lessons", "users"
end
