# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140325232015) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "web_pages", force: true do |t|
    t.string   "url",                                    null: false
    t.text     "entities_api_response"
    t.text     "entities_high_relevance"
    t.text     "entities_med_relevance"
    t.text     "entities_low_relevance"
    t.text     "keywords_api_response"
    t.text     "keywords_high_relevance"
    t.text     "keywords_med_relevance"
    t.text     "keywords_low_relevance"
    t.text     "concepts_api_response"
    t.text     "concepts_high_relevance"
    t.text     "concepts_med_relevance"
    t.text     "concepts_low_relevance"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "screenshot_file_name"
    t.integer  "screenshot_file_size"
    t.string   "screenshot_content_type"
    t.datetime "screenshot_updated_at"
    t.boolean  "active",                  default: true
  end

  add_index "web_pages", ["title"], name: "index_web_pages_on_title", using: :btree
  add_index "web_pages", ["url"], name: "index_web_pages_on_url", using: :btree

end
