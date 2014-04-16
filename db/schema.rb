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

ActiveRecord::Schema.define(version: 20140416190744) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", id: false, force: true do |t|
    t.integer  "id",         default: "nextval('accounts_id_seq'::regclass)", null: false
    t.string   "name"
    t.string   "paymill_id"
    t.integer  "user_id"
    t.boolean  "active"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  create_table "activities", id: false, force: true do |t|
    t.integer  "id",                                   default: "nextval('activities_id_seq'::regclass)", null: false
    t.integer  "user_id"
    t.integer  "sub_instance_id"
    t.string   "type",                      limit: 60
    t.string   "class_name",                limit: 60
    t.string   "status",                    limit: 8
    t.integer  "idea_id"
    t.datetime "created_at"
    t.boolean  "is_user_only",                         default: false
    t.integer  "comments_count",                       default: 0
    t.integer  "activity_id"
    t.integer  "other_user_id"
    t.integer  "tag_id"
    t.integer  "point_id"
    t.integer  "revision_id"
    t.integer  "capital_id"
    t.integer  "ad_id"
    t.integer  "position"
    t.integer  "followers_count",                      default: 0
    t.datetime "changed_at"
    t.integer  "idea_status_change_log_id"
    t.integer  "group_id"
    t.integer  "idea_revision_id"
    t.text     "custom_text"
  end

  create_table "ads", id: false, force: true do |t|
    t.integer  "id",                                                   default: "nextval('ads_id_seq'::regclass)", null: false
    t.integer  "idea_id"
    t.integer  "user_id"
    t.integer  "show_ads_count",                                       default: 0
    t.integer  "shown_ads_count",                                      default: 0
    t.integer  "cost"
    t.decimal  "per_user_cost",               precision: 11, scale: 0
    t.decimal  "spent",                       precision: 11, scale: 0, default: 0
    t.integer  "yes_count",                                            default: 0
    t.integer  "no_count",                                             default: 0
    t.integer  "skip_count",                                           default: 0
    t.string   "status",          limit: 40
    t.string   "content",         limit: 140
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "finished_at"
    t.integer  "position",                                             default: 0
    t.integer  "sub_instance_id"
  end

  create_table "auto_authentications", id: false, force: true do |t|
    t.integer  "id",         default: "nextval('auto_authentications_id_seq'::regclass)", null: false
    t.string   "secret"
    t.boolean  "active",     default: true
    t.integer  "user_id"
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
  end

  create_table "capitals", id: false, force: true do |t|
    t.integer  "id",                            default: "nextval('capitals_id_seq'::regclass)", null: false
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "capitalizable_id"
    t.string   "capitalizable_type"
    t.integer  "amount",                        default: 0
    t.string   "type",               limit: 60
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_undo",                       default: false
  end

  create_table "categories", id: false, force: true do |t|
    t.integer  "id",                           default: "nextval('categories_id_seq'::regclass)", null: false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sub_instance_id"
    t.string   "icon_file_name"
    t.string   "icon_content_type", limit: 30
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.text     "description"
    t.string   "sub_tags"
  end

  create_table "color_schemes", id: false, force: true do |t|
    t.integer  "id",                                       default: "nextval('color_schemes_id_seq'::regclass)", null: false
    t.string   "nav_background",                limit: 6,  default: "f0f0f0"
    t.string   "nav_text",                      limit: 6,  default: "000000"
    t.string   "nav_selected_background",       limit: 6,  default: "dddddd"
    t.string   "nav_selected_text",             limit: 6,  default: "000000"
    t.string   "nav_hover_background",          limit: 6,  default: "13499b"
    t.string   "nav_hover_text",                limit: 6,  default: "ffffff"
    t.string   "background",                    limit: 6,  default: "ffffff"
    t.string   "box",                           limit: 6,  default: "f0f0f0"
    t.string   "text",                          limit: 6,  default: "444444"
    t.string   "link",                          limit: 6,  default: "13499b"
    t.string   "heading",                       limit: 6,  default: "000000"
    t.string   "sub_heading",                   limit: 6,  default: "999999"
    t.string   "greyed_out",                    limit: 6,  default: "999999"
    t.string   "border",                        limit: 6,  default: "dddddd"
    t.string   "error",                         limit: 6,  default: "bc0000"
    t.string   "error_text",                    limit: 6,  default: "ffffff"
    t.string   "down",                          limit: 6,  default: "bc0000"
    t.string   "up",                            limit: 6,  default: "009933"
    t.string   "action_button",                 limit: 6,  default: "ffff99"
    t.string   "action_button_border",          limit: 6,  default: "ffcc00"
    t.string   "endorsed_button",               limit: 6,  default: "009933"
    t.string   "endorsed_button_text",          limit: 6,  default: "ffffff"
    t.string   "opposed_button",                limit: 6,  default: "bc0000"
    t.string   "opposed_button_text",           limit: 6,  default: "ffffff"
    t.string   "compromised_button",            limit: 6,  default: "ffcc00"
    t.string   "compromised_button_text",       limit: 6,  default: "ffffff"
    t.string   "grey_button",                   limit: 6,  default: "f0f0f0"
    t.string   "grey_button_border",            limit: 6,  default: "cccccc"
    t.string   "fonts",                         limit: 50, default: "Arial, Helvetica, sans-serif"
    t.boolean  "background_tiled",                         default: false
    t.string   "main",                          limit: 6,  default: "FFFFFF"
    t.string   "comments",                      limit: 6,  default: "F0F0F0"
    t.string   "comments_text",                 limit: 6,  default: "444444"
    t.string   "input",                         limit: 6,  default: "444444"
    t.string   "box_text",                      limit: 6,  default: "444444"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_featured",                              default: false
    t.string   "name",                          limit: 60
    t.string   "footer",                        limit: 6
    t.string   "footer_text",                   limit: 6
    t.string   "grey_button_text",              limit: 6
    t.string   "action_button_text",            limit: 6
    t.string   "background_image_file_name"
    t.string   "background_image_content_type"
    t.integer  "background_image_file_size"
    t.datetime "background_image_updated_at"
  end

  create_table "comments", id: false, force: true do |t|
    t.integer  "id",              default: "nextval('comments_id_seq'::regclass)", null: false
    t.integer  "activity_id"
    t.integer  "user_id"
    t.string   "status"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_endorser",     default: false
    t.string   "ip_address"
    t.string   "user_agent"
    t.string   "referrer"
    t.boolean  "is_opposer",      default: false
    t.text     "content_html"
    t.integer  "flags_count",     default: 0
    t.integer  "category_id"
    t.string   "category_name",   default: "no cat"
    t.integer  "sub_instance_id"
  end

  create_table "delayed_jobs", id: false, force: true do |t|
    t.integer  "id",         default: "nextval('delayed_jobs_id_seq'::regclass)", null: false
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue"
  end

  create_table "donations", id: false, force: true do |t|
    t.integer  "id",                     default: "nextval('donations_id_seq'::regclass)", null: false
    t.string   "cardholder_name"
    t.string   "email"
    t.string   "paymill_client_id"
    t.string   "paymill_transaction_id"
    t.string   "currency"
    t.float    "amount"
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
    t.string   "organisation_name"
    t.string   "display_name"
    t.boolean  "anonymous_donor",        default: true
    t.integer  "external_project_id"
  end

  create_table "endorsements", id: false, force: true do |t|
    t.integer  "id",                         default: "nextval('endorsements_id_seq'::regclass)", null: false
    t.string   "status",          limit: 50
    t.integer  "position"
    t.integer  "sub_instance_id"
    t.integer  "idea_id"
    t.integer  "user_id"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "referral_id"
    t.integer  "value",                      default: 1
    t.integer  "score",                      default: 0
  end

  create_table "feeds", id: false, force: true do |t|
    t.integer  "id",                default: "nextval('feeds_id_seq'::regclass)", null: false
    t.string   "name"
    t.string   "website_link"
    t.string   "feed_link"
    t.string   "cached_issue_list"
    t.datetime "crawled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "following_discussions", id: false, force: true do |t|
    t.integer  "id",          default: "nextval('following_discussions_id_seq'::regclass)", null: false
    t.integer  "user_id"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "followings", id: false, force: true do |t|
    t.integer  "id",            default: "nextval('followings_id_seq'::regclass)", null: false
    t.integer  "user_id"
    t.integer  "other_user_id"
    t.integer  "value",         default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", id: false, force: true do |t|
    t.integer "id",              default: "nextval('groups_id_seq'::regclass)", null: false
    t.string  "name"
    t.text    "description"
    t.integer "sub_instance_id"
  end

  create_table "groups_users", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.boolean "is_admin", default: false
  end

  create_table "idea_charts", id: false, force: true do |t|
    t.integer  "id",                                      default: "nextval('idea_charts_id_seq'::regclass)", null: false
    t.integer  "idea_id"
    t.integer  "date_year"
    t.integer  "date_month"
    t.integer  "date_day"
    t.integer  "position"
    t.integer  "up_count"
    t.integer  "down_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "volume_count"
    t.decimal  "change_percent", precision: 11, scale: 0, default: 0
    t.integer  "change",                                  default: 0
  end

  create_table "idea_revisions", id: false, force: true do |t|
    t.integer  "id",                           default: "nextval('idea_revisions_id_seq'::regclass)", null: false
    t.integer  "idea_id"
    t.integer  "user_id"
    t.string   "status",           limit: 50
    t.string   "name",             limit: 250
    t.text     "description"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip_address"
    t.string   "user_agent",       limit: 150
    t.text     "name_diff"
    t.text     "description_diff"
    t.integer  "other_idea_id"
    t.text     "description_html"
    t.integer  "category_id"
    t.text     "notes"
    t.text     "notes_diff"
  end

  create_table "idea_status_change_logs", id: false, force: true do |t|
    t.integer  "id",         default: "nextval('idea_status_change_logs_id_seq'::regclass)", null: false
    t.integer  "idea_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content"
    t.string   "subject",                                                                    null: false
    t.date     "date"
  end

  create_table "ideas", id: false, force: true do |t|
    t.integer  "id",                                   default: "nextval('ideas_id_seq'::regclass)", null: false
    t.integer  "position",                             default: 0,                                   null: false
    t.integer  "user_id"
    t.string   "name",                     limit: 250
    t.text     "description"
    t.integer  "endorsements_count",                   default: 0,                                   null: false
    t.string   "status",                   limit: 50
    t.string   "ip_address"
    t.datetime "removed_at"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position_1hr",                         default: 0,                                   null: false
    t.integer  "position_24hr",                        default: 0,                                   null: false
    t.integer  "position_7days",                       default: 0,                                   null: false
    t.integer  "position_30days",                      default: 0,                                   null: false
    t.integer  "position_1hr_delta",                   default: 0,                                   null: false
    t.integer  "position_24hr_delta",                  default: 0,                                   null: false
    t.integer  "position_7days_delta",                 default: 0,                                   null: false
    t.integer  "position_30days_delta",                default: 0,                                   null: false
    t.integer  "change_id"
    t.string   "cached_issue_list"
    t.integer  "up_endorsements_count",                default: 0
    t.integer  "down_endorsements_count",              default: 0
    t.integer  "points_count",                         default: 0
    t.integer  "up_points_count",                      default: 0
    t.integer  "down_points_count",                    default: 0
    t.integer  "neutral_points_count",                 default: 0
    t.integer  "discussions_count",                    default: 0
    t.integer  "relationships_count",                  default: 0
    t.integer  "changes_count",                        default: 0
    t.integer  "official_status",                      default: 0
    t.integer  "official_value",                       default: 0
    t.datetime "status_changed_at"
    t.integer  "score",                                default: 0
    t.string   "short_url",                limit: 20
    t.boolean  "is_controversial",                     default: false
    t.integer  "trending_score",                       default: 0
    t.integer  "controversial_score",                  default: 0
    t.string   "external_info_1"
    t.string   "external_info_2"
    t.string   "external_info_3"
    t.string   "external_link"
    t.string   "external_presenter"
    t.string   "external_id"
    t.string   "external_name"
    t.integer  "sub_instance_id"
    t.integer  "flags_count",                          default: 0
    t.integer  "category_id"
    t.string   "user_agent",               limit: 200
    t.integer  "position_endorsed_24hr"
    t.integer  "position_endorsed_7days"
    t.integer  "position_endorsed_30days"
    t.text     "finished_status_message"
    t.integer  "external_session_id"
    t.string   "finished_status_subject"
    t.date     "finished_status_date"
    t.integer  "group_id"
    t.integer  "idea_revision_id"
    t.string   "author_sentence"
    t.integer  "idea_revisions_count",                 default: 0
    t.text     "notes"
    t.integer  "impressions_count"
    t.string   "occurred_at"
  end

  create_table "impressions", id: false, force: true do |t|
    t.integer  "id",                  default: "nextval('impressions_id_seq'::regclass)", null: false
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
  end

  create_table "instances", id: false, force: true do |t|
    t.integer  "id",                                          default: "nextval('instances_id_seq'::regclass)", null: false
    t.string   "status",                          limit: 30
    t.string   "short_name",                      limit: 20
    t.string   "domain_name",                     limit: 60
    t.string   "layout",                          limit: 20
    t.string   "name",                            limit: 60
    t.string   "tagline",                         limit: 100
    t.string   "email",                           limit: 100
    t.boolean  "is_public",                                   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "db_name",                         limit: 20
    t.string   "target",                          limit: 30
    t.boolean  "is_tags",                                     default: true
    t.boolean  "is_facebook",                                 default: true
    t.string   "admin_name",                      limit: 60
    t.string   "admin_email",                     limit: 100
    t.string   "google_analytics_code",           limit: 15
    t.string   "quantcast_code",                  limit: 20
    t.string   "tags_name",                       limit: 20,  default: "Category"
    t.string   "currency_name",                   limit: 30,  default: "political capital"
    t.string   "currency_short_name",             limit: 3,   default: "pc"
    t.string   "homepage",                        limit: 20,  default: "top"
    t.integer  "ideas_count",                                 default: 0
    t.integer  "points_count",                                default: 0
    t.integer  "users_count",                                 default: 0
    t.integer  "contributors_count",                          default: 0
    t.integer  "sub_instances_count",                         default: 0
    t.integer  "endorsements_count",                          default: 0
    t.integer  "picture_id"
    t.integer  "color_scheme_id",                             default: 1
    t.string   "mission",                         limit: 200
    t.string   "prompt",                          limit: 100
    t.integer  "buddy_icon_id"
    t.integer  "fav_icon_id"
    t.boolean  "is_suppress_empty_ideas",                     default: false
    t.string   "tags_page",                       limit: 20,  default: "list"
    t.string   "facebook_api_key",                limit: 32
    t.string   "facebook_secret_key",             limit: 32
    t.string   "windows_appid",                   limit: 32
    t.string   "windows_secret_key",              limit: 32
    t.string   "yahoo_appid",                     limit: 40
    t.string   "yahoo_secret_key",                limit: 32
    t.boolean  "is_twitter",                                  default: true
    t.string   "twitter_key",                     limit: 46
    t.string   "twitter_secret_key",              limit: 46
    t.string   "language_code",                   limit: 2,   default: "en"
    t.string   "password",                        limit: 40
    t.string   "logo_file_name"
    t.string   "logo_content_type",               limit: 30
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "buddy_icon_file_name"
    t.string   "buddy_icon_content_type",         limit: 30
    t.integer  "buddy_icon_file_size"
    t.datetime "buddy_icon_updated_at"
    t.string   "fav_icon_file_name"
    t.string   "fav_icon_content_type",           limit: 30
    t.integer  "fav_icon_file_size"
    t.datetime "fav_icon_updated_at"
    t.boolean  "google_login_enabled",                        default: false
    t.string   "default_tags_checkbox"
    t.text     "message_to_users"
    t.text     "description"
    t.text     "message_for_ads"
    t.text     "message_for_issues"
    t.text     "message_for_network"
    t.text     "message_for_finished"
    t.text     "message_for_points"
    t.text     "message_for_new_idea"
    t.text     "message_for_news"
    t.string   "email_banner_file_name"
    t.string   "email_banner_content_type"
    t.integer  "email_banner_file_size"
    t.datetime "email_banner_updated_at"
    t.string   "top_banner_file_name"
    t.string   "top_banner_content_type",         limit: 30
    t.integer  "top_banner_file_size"
    t.datetime "top_banner_updated_at"
    t.string   "menu_strip_file_name"
    t.string   "menu_strip_content_type",         limit: 30
    t.integer  "menu_strip_file_size"
    t.datetime "menu_strip_updated_at"
    t.string   "menu_strip_side_file_name"
    t.string   "menu_strip_side_content_type",    limit: 30
    t.integer  "menu_strip_side_file_size"
    t.datetime "menu_strip_side_updated_at"
    t.string   "favicon_file_name"
    t.string   "favicon_content_type",            limit: 30
    t.integer  "favicon_file_size"
    t.datetime "favicon_updated_at"
    t.string   "left_link_url"
    t.string   "right_link_url"
    t.integer  "left_link_position",                          default: 0
    t.integer  "left_link_width",                             default: 400
    t.integer  "right_link_position",                         default: 900
    t.integer  "right_link_width",                            default: 120
    t.boolean  "disable_email_login",                         default: false
    t.string   "external_link_logo_file_name"
    t.string   "external_link_logo_content_type", limit: 30
    t.integer  "external_link_logo_file_size"
    t.datetime "external_link_logo_updated_at"
    t.string   "external_link"
    t.string   "layout_for_subscriptions",                    default: "application"
    t.string   "sales_email"
    t.string   "about_page_name"
    t.string   "default_locale",                              default: "en"
  end

  create_table "monologue_posts", id: false, force: true do |t|
    t.integer  "id",                default: "nextval('monologue_posts_id_seq'::regclass)", null: false
    t.integer  "posts_revision_id"
    t.boolean  "published"
    t.datetime "created_at",                                                                null: false
    t.datetime "updated_at",                                                                null: false
  end

  create_table "monologue_posts_revisions", id: false, force: true do |t|
    t.integer  "id",           default: "nextval('monologue_posts_revisions_id_seq'::regclass)", null: false
    t.string   "title"
    t.text     "content"
    t.string   "url"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "published_at"
    t.datetime "created_at",                                                                     null: false
    t.datetime "updated_at",                                                                     null: false
  end

  create_table "monologue_taggings", id: false, force: true do |t|
    t.integer "id",      default: "nextval('monologue_taggings_id_seq'::regclass)", null: false
    t.integer "post_id"
    t.integer "tag_id"
  end

  create_table "monologue_tags", id: false, force: true do |t|
    t.integer "id",   default: "nextval('monologue_tags_id_seq'::regclass)", null: false
    t.string  "name"
  end

  create_table "monologue_users", id: false, force: true do |t|
    t.integer  "id",              default: "nextval('monologue_users_id_seq'::regclass)", null: false
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
  end

  create_table "notifications", id: false, force: true do |t|
    t.integer  "id",                         default: "nextval('notifications_id_seq'::regclass)", null: false
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "status",          limit: 20
    t.string   "type",            limit: 60
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sent_at"
    t.datetime "read_at"
    t.datetime "processed_at"
    t.datetime "removed_at"
    t.text     "custom_text"
  end

  create_table "pages", id: false, force: true do |t|
    t.integer  "id",                          default: "nextval('pages_id_seq'::regclass)", null: false
    t.text     "title"
    t.text     "content"
    t.datetime "created_at",                                                                null: false
    t.datetime "updated_at",                                                                null: false
    t.integer  "weight",                      default: 0
    t.integer  "sub_instance_id"
    t.string   "name"
    t.boolean  "hide_from_menu",              default: false
    t.boolean  "hide_from_menu_unless_admin", default: false
  end

  create_table "pictures", id: false, force: true do |t|
    t.integer  "id",                       default: "nextval('pictures_id_seq'::regclass)", null: false
    t.string   "name",         limit: 200
    t.integer  "height",       limit: 8
    t.integer  "width",        limit: 8
    t.string   "content_type", limit: 100
    t.binary   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", id: false, force: true do |t|
    t.integer  "id",               default: "nextval('plans_id_seq'::regclass)", null: false
    t.text     "name"
    t.text     "description"
    t.string   "currency"
    t.integer  "max_users"
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.boolean  "private_instance", default: false
    t.boolean  "active",           default: true
    t.float    "amount"
    t.float    "vat"
    t.string   "paymill_offer_id"
  end

  create_table "point_qualities", id: false, force: true do |t|
    t.integer  "id",         default: "nextval('point_qualities_id_seq'::regclass)", null: false
    t.integer  "user_id"
    t.integer  "point_id"
    t.boolean  "value",      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "points", id: false, force: true do |t|
    t.integer  "id",                                                            default: "nextval('points_id_seq'::regclass)", null: false
    t.integer  "revision_id"
    t.integer  "idea_id"
    t.integer  "other_idea_id"
    t.integer  "user_id"
    t.integer  "value",                                                         default: 0
    t.integer  "revisions_count",                                               default: 0
    t.string   "status",                   limit: 50
    t.string   "name",                     limit: 122
    t.text     "content"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "website"
    t.string   "author_sentence"
    t.integer  "helpful_count",                                                 default: 0
    t.integer  "unhelpful_count",                                               default: 0
    t.integer  "discussions_count",                                             default: 0
    t.integer  "endorser_helpful_count",                                        default: 0
    t.integer  "opposer_helpful_count",                                         default: 0
    t.integer  "endorser_unhelpful_count",                                      default: 0
    t.integer  "opposer_unhelpful_count",                                       default: 0
    t.integer  "neutral_helpful_count",                                         default: 0
    t.integer  "neutral_unhelpful_count",                                       default: 0
    t.decimal  "score",                                precision: 11, scale: 0, default: 0
    t.decimal  "endorser_score",                       precision: 11, scale: 0, default: 0
    t.decimal  "opposer_score",                        precision: 11, scale: 0, default: 0
    t.decimal  "neutral_score",                        precision: 11, scale: 0, default: 0
    t.text     "content_html"
    t.integer  "sub_instance_id"
    t.integer  "flags_count",                                                   default: 0
    t.string   "user_agent",               limit: 200
    t.string   "ip_address"
  end

  create_table "profiles", id: false, force: true do |t|
    t.integer  "id",         default: "nextval('profiles_id_seq'::regclass)", null: false
    t.integer  "user_id"
    t.text     "bio"
    t.text     "bio_html"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rankings", id: false, force: true do |t|
    t.integer  "id",                 default: "nextval('rankings_id_seq'::regclass)", null: false
    t.integer  "idea_id"
    t.integer  "version",            default: 0
    t.integer  "position"
    t.integer  "endorsements_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sub_instance_id"
  end

  create_table "relationships", id: false, force: true do |t|
    t.integer  "id",                       default: "nextval('relationships_id_seq'::regclass)", null: false
    t.integer  "idea_id"
    t.integer  "other_idea_id"
    t.string   "type",          limit: 70
    t.integer  "percentage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "revisions", id: false, force: true do |t|
    t.integer  "id",                        default: "nextval('revisions_id_seq'::regclass)", null: false
    t.integer  "point_id"
    t.integer  "user_id"
    t.integer  "value",                     default: 0,                                       null: false
    t.string   "status",        limit: 50
    t.string   "name",          limit: 60
    t.text     "content"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip_address"
    t.string   "user_agent",    limit: 150
    t.string   "website",       limit: 100
    t.text     "content_diff"
    t.integer  "other_idea_id"
    t.text     "content_html"
  end

  create_table "shown_ads", id: false, force: true do |t|
    t.integer  "id",                      default: "nextval('shown_ads_id_seq'::regclass)", null: false
    t.integer  "ad_id"
    t.integer  "user_id"
    t.integer  "value",                   default: 0
    t.string   "ip_address"
    t.string   "user_agent", limit: 1000
    t.string   "referrer",   limit: 1000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "seen_count",              default: 1
  end

  create_table "signups", id: false, force: true do |t|
    t.integer  "id",                         default: "nextval('signups_id_seq'::regclass)", null: false
    t.integer  "sub_instance_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip_address",      limit: 16
  end

  create_table "sub_instances", id: false, force: true do |t|
    t.integer  "id",                                          default: "nextval('sub_instances_id_seq'::regclass)", null: false
    t.string   "name",                            limit: 60
    t.string   "short_name",                      limit: 50,                                                        null: false
    t.integer  "picture_id"
    t.integer  "is_optin",                        limit: 2,   default: 0,                                           null: false
    t.string   "optin_text",                      limit: 60
    t.string   "privacy_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "is_active",                       limit: 2,   default: 1,                                           null: false
    t.string   "status",                                      default: "passive"
    t.integer  "users_count",                                 default: 0
    t.string   "website"
    t.datetime "removed_at"
    t.string   "ip_address"
    t.boolean  "is_daily_summary",                            default: true
    t.string   "unsubscribe_url"
    t.string   "subscribe_url"
    t.string   "logo_file_name"
    t.string   "logo_content_type",               limit: 30
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "top_banner_file_name"
    t.string   "top_banner_content_type",         limit: 30
    t.integer  "top_banner_file_size"
    t.datetime "top_banner_updated_at"
    t.string   "menu_strip_file_name"
    t.string   "menu_strip_content_type",         limit: 30
    t.integer  "menu_strip_file_size"
    t.datetime "menu_strip_updated_at"
    t.string   "menu_strip_side_file_name"
    t.string   "menu_strip_side_content_type",    limit: 30
    t.integer  "menu_strip_side_file_size"
    t.datetime "menu_strip_side_updated_at"
    t.string   "add_idea_button_file_name"
    t.string   "add_idea_button_content_type",    limit: 30
    t.integer  "add_idea_button_file_size"
    t.datetime "add_idea_button_updated_at"
    t.string   "default_tags"
    t.string   "custom_tag_checkbox"
    t.string   "custom_tag_dropdown_1"
    t.string   "custom_tag_dropdown_2"
    t.string   "name_variations_data",            limit: 350
    t.boolean  "geoblocking_enabled",                         default: false
    t.string   "geoblocking_open_countries",                  default: ""
    t.string   "default_locale"
    t.integer  "iso_country_id"
    t.string   "required_tags"
    t.text     "message_for_new_idea"
    t.string   "parent_tag"
    t.text     "message_to_users"
    t.string   "google_analytics_code"
    t.text     "custom_css"
    t.text     "sub_link_header"
    t.boolean  "use_category_home_page",                      default: false
    t.boolean  "hide_description",                            default: false
    t.boolean  "hide_world_icon",                             default: false
    t.integer  "idea_name_max_length",                        default: 60
    t.string   "left_link_url"
    t.string   "right_link_url"
    t.integer  "left_link_position",                          default: 0
    t.integer  "left_link_width",                             default: 400
    t.integer  "right_link_position",                         default: 900
    t.integer  "right_link_width",                            default: 120
    t.text     "block_new_ideas"
    t.text     "block_points"
    t.text     "block_comments"
    t.text     "block_endorsements"
    t.string   "stage_name"
    t.text     "stage_description"
    t.string   "external_link"
    t.string   "external_link_logo_file_name"
    t.string   "external_link_logo_content_type", limit: 30
    t.integer  "external_link_logo_file_size"
    t.datetime "external_link_logo_updated_at"
    t.string   "http_auth_username"
    t.string   "http_auth_password"
    t.boolean  "subscription_enabled",                        default: false
    t.integer  "subscription_id"
    t.integer  "account_id"
    t.string   "home_page_partial",                           default: "index"
    t.string   "home_page_layout",                            default: "application"
    t.boolean  "lock_users_to_instance",                      default: false
    t.boolean  "setup_in_progress",                           default: false
    t.text     "map_coordinates"
    t.string   "organization_type"
    t.string   "redirect_url"
    t.text     "description"
    t.boolean  "use_live_home_page",                          default: false
    t.string   "live_stream_id"
  end

  create_table "subscriptions", id: false, force: true do |t|
    t.integer  "id",              default: "nextval('subscriptions_id_seq'::regclass)", null: false
    t.string   "paymill_id"
    t.integer  "user_id"
    t.integer  "plan_id"
    t.datetime "last_payment_at"
    t.boolean  "active"
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.integer  "account_id"
  end

  create_table "tag_subscriptions", id: false, force: true do |t|
    t.integer "user_id", null: false
    t.integer "tag_id",  null: false
  end

  create_table "taggings", id: false, force: true do |t|
    t.integer  "id",                       default: "nextval('taggings_id_seq'::regclass)", null: false
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 50
    t.string   "taggable_type", limit: 50
    t.string   "context",       limit: 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", id: false, force: true do |t|
    t.integer  "id",                                default: "nextval('tags_id_seq'::regclass)", null: false
    t.string   "name",                  limit: 60
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "top_idea_id"
    t.integer  "up_endorsers_count",                default: 0
    t.integer  "down_endorsers_count",              default: 0
    t.integer  "controversial_idea_id"
    t.integer  "rising_idea_id"
    t.integer  "official_idea_id"
    t.integer  "webpages_count",                    default: 0
    t.integer  "ideas_count",                       default: 0
    t.integer  "feeds_count",                       default: 0
    t.string   "title",                 limit: 60
    t.string   "description",           limit: 200
    t.integer  "discussions_count",                 default: 0
    t.integer  "points_count",                      default: 0
    t.string   "prompt",                limit: 100
    t.string   "slug",                  limit: 60
    t.integer  "sub_instance_id"
    t.integer  "tag_type"
  end

  create_table "tolk_locales", id: false, force: true do |t|
    t.integer  "id",         default: "nextval('tolk_locales_id_seq'::regclass)", null: false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "weight",     default: 1000
  end

  create_table "tolk_phrases", id: false, force: true do |t|
    t.integer  "id",         default: "nextval('tolk_phrases_id_seq'::regclass)", null: false
    t.text     "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tolk_translations", id: false, force: true do |t|
    t.integer  "id",              default: "nextval('tolk_translations_id_seq'::regclass)", null: false
    t.integer  "phrase_id"
    t.integer  "locale_id"
    t.text     "text"
    t.text     "previous_text"
    t.boolean  "primary_updated", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tr8n_glossary", id: false, force: true do |t|
    t.integer  "id",          default: "nextval('tr8n_glossary_id_seq'::regclass)", null: false
    t.string   "keyword"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tr8n_ip_locations", id: false, force: true do |t|
    t.integer  "id",                    default: "nextval('tr8n_ip_locations_id_seq'::regclass)", null: false
    t.integer  "low",        limit: 8
    t.integer  "high",       limit: 8
    t.string   "registry",   limit: 20
    t.date     "assigned"
    t.string   "ctry",       limit: 2
    t.string   "cntry",      limit: 3
    t.string   "country",    limit: 80
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tr8n_iso_countries", id: false, force: true do |t|
    t.integer  "id",                   default: "nextval('tr8n_iso_countries_id_seq'::regclass)", null: false
    t.string   "code",                                                                            null: false
    t.string   "country_english_name",                                                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "map_coordinates"
    t.string   "default_locale",       default: "en"
  end

  create_table "tr8n_iso_countries_tr8n_languages", id: false, force: true do |t|
    t.integer "tr8n_iso_country_id"
    t.integer "tr8n_language_id"
  end

  create_table "tr8n_language_case_rules", id: false, force: true do |t|
    t.integer  "id",               default: "nextval('tr8n_language_case_rules_id_seq'::regclass)", null: false
    t.integer  "language_case_id",                                                                  null: false
    t.integer  "language_id"
    t.integer  "translator_id"
    t.text     "definition",                                                                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "tr8n_language_case_value_maps", id: false, force: true do |t|
    t.integer  "id",            default: "nextval('tr8n_language_case_value_maps_id_seq'::regclass)", null: false
    t.string   "keyword",                                                                             null: false
    t.integer  "language_id",                                                                         null: false
    t.integer  "translator_id"
    t.text     "map"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "reported"
  end

  create_table "tr8n_language_cases", id: false, force: true do |t|
    t.integer  "id",            default: "nextval('tr8n_language_cases_id_seq'::regclass)", null: false
    t.integer  "language_id",                                                               null: false
    t.integer  "translator_id"
    t.string   "keyword"
    t.string   "latin_name"
    t.string   "native_name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "application"
  end

  create_table "tr8n_language_forum_abuse_reports", id: false, force: true do |t|
    t.integer  "id",                        default: "nextval('tr8n_language_forum_abuse_reports_id_seq'::regclass)", null: false
    t.integer  "language_id",                                                                                         null: false
    t.integer  "translator_id",                                                                                       null: false
    t.integer  "language_forum_message_id",                                                                           null: false
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tr8n_language_forum_messages", id: false, force: true do |t|
    t.integer  "id",                      default: "nextval('tr8n_language_forum_messages_id_seq'::regclass)", null: false
    t.integer  "language_id",                                                                                  null: false
    t.integer  "language_forum_topic_id",                                                                      null: false
    t.integer  "translator_id",                                                                                null: false
    t.text     "message",                                                                                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tr8n_language_forum_topics", id: false, force: true do |t|
    t.integer  "id",            default: "nextval('tr8n_language_forum_topics_id_seq'::regclass)", null: false
    t.integer  "translator_id",                                                                    null: false
    t.integer  "language_id"
    t.text     "topic",                                                                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tr8n_language_metrics", id: false, force: true do |t|
    t.integer  "id",                   default: "nextval('tr8n_language_metrics_id_seq'::regclass)", null: false
    t.string   "type"
    t.integer  "language_id",                                                                        null: false
    t.date     "metric_date"
    t.integer  "user_count",           default: 0
    t.integer  "translator_count",     default: 0
    t.integer  "translation_count",    default: 0
    t.integer  "key_count",            default: 0
    t.integer  "locked_key_count",     default: 0
    t.integer  "translated_key_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tr8n_language_rules", id: false, force: true do |t|
    t.integer  "id",            default: "nextval('tr8n_language_rules_id_seq'::regclass)", null: false
    t.integer  "language_id",                                                               null: false
    t.integer  "translator_id"
    t.string   "type"
    t.text     "definition"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tr8n_language_users", id: false, force: true do |t|
    t.integer  "id",            default: "nextval('tr8n_language_users_id_seq'::regclass)", null: false
    t.integer  "language_id",                                                               null: false
    t.integer  "user_id",                                                                   null: false
    t.integer  "translator_id"
    t.boolean  "manager",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tr8n_languages", id: false, force: true do |t|
    t.integer  "id",                   default: "nextval('tr8n_languages_id_seq'::regclass)", null: false
    t.string   "locale",                                                                      null: false
    t.string   "english_name",                                                                null: false
    t.string   "native_name"
    t.boolean  "enabled"
    t.boolean  "right_to_left"
    t.integer  "completeness"
    t.integer  "fallback_language_id"
    t.text     "curse_words"
    t.integer  "featured_index",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "google_key"
    t.string   "facebook_key"
  end

  create_table "tr8n_sync_logs", id: false, force: true do |t|
    t.integer  "id",                    default: "nextval('tr8n_sync_logs_id_seq'::regclass)", null: false
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer  "keys_sent"
    t.integer  "translations_sent"
    t.integer  "keys_received"
    t.integer  "translations_received"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tr8n_translation_domains", id: false, force: true do |t|
    t.integer  "id",           default: "nextval('tr8n_translation_domains_id_seq'::regclass)", null: false
    t.string   "name"
    t.string   "description"
    t.integer  "source_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tr8n_translation_key_comments", id: false, force: true do |t|
    t.integer  "id",                 default: "nextval('tr8n_translation_key_comments_id_seq'::regclass)", null: false
    t.integer  "language_id",                                                                              null: false
    t.integer  "translation_key_id",                                                                       null: false
    t.integer  "translator_id",                                                                            null: false
    t.text     "message",                                                                                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tr8n_translation_key_locks", id: false, force: true do |t|
    t.integer  "id",                 default: "nextval('tr8n_translation_key_locks_id_seq'::regclass)", null: false
    t.integer  "translation_key_id",                                                                    null: false
    t.integer  "language_id",                                                                           null: false
    t.integer  "translator_id"
    t.boolean  "locked",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tr8n_translation_key_sources", id: false, force: true do |t|
    t.integer  "id",                    default: "nextval('tr8n_translation_key_sources_id_seq'::regclass)", null: false
    t.integer  "translation_key_id",                                                                         null: false
    t.integer  "translation_source_id",                                                                      null: false
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tr8n_translation_keys", id: false, force: true do |t|
    t.integer  "id",                default: "nextval('tr8n_translation_keys_id_seq'::regclass)", null: false
    t.string   "key",                                                                             null: false
    t.text     "label",                                                                           null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "verified_at"
    t.integer  "translation_count"
    t.boolean  "admin"
    t.string   "locale"
    t.integer  "level",             default: 0
    t.datetime "synced_at"
    t.string   "type"
  end

  create_table "tr8n_translation_source_languages", id: false, force: true do |t|
    t.integer  "id",                    default: "nextval('tr8n_translation_source_languages_id_seq'::regclass)", null: false
    t.integer  "language_id"
    t.integer  "translation_source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tr8n_translation_sources", id: false, force: true do |t|
    t.integer  "id",                    default: "nextval('tr8n_translation_sources_id_seq'::regclass)", null: false
    t.string   "source"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "translation_domain_id"
  end

  create_table "tr8n_translation_votes", id: false, force: true do |t|
    t.integer  "id",             default: "nextval('tr8n_translation_votes_id_seq'::regclass)", null: false
    t.integer  "translation_id",                                                                null: false
    t.integer  "translator_id",                                                                 null: false
    t.integer  "vote",                                                                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tr8n_translations", id: false, force: true do |t|
    t.integer  "id",                           default: "nextval('tr8n_translations_id_seq'::regclass)", null: false
    t.integer  "translation_key_id",                                                                     null: false
    t.integer  "language_id",                                                                            null: false
    t.integer  "translator_id",                                                                          null: false
    t.text     "label",                                                                                  null: false
    t.integer  "rank",                         default: 0
    t.integer  "approved_by_id",     limit: 8
    t.text     "rules"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "synced_at"
  end

  create_table "tr8n_translator_following", id: false, force: true do |t|
    t.integer  "id",            default: "nextval('tr8n_translator_following_id_seq'::regclass)", null: false
    t.integer  "translator_id"
    t.integer  "object_id"
    t.string   "object_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tr8n_translator_logs", id: false, force: true do |t|
    t.integer  "id",                      default: "nextval('tr8n_translator_logs_id_seq'::regclass)", null: false
    t.integer  "translator_id"
    t.integer  "user_id",       limit: 8
    t.string   "action"
    t.integer  "action_level"
    t.string   "reason"
    t.string   "reference"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tr8n_translator_metrics", id: false, force: true do |t|
    t.integer  "id",                              default: "nextval('tr8n_translator_metrics_id_seq'::regclass)", null: false
    t.integer  "translator_id",                                                                                   null: false
    t.integer  "language_id",           limit: 8
    t.integer  "total_translations",              default: 0
    t.integer  "total_votes",                     default: 0
    t.integer  "positive_votes",                  default: 0
    t.integer  "negative_votes",                  default: 0
    t.integer  "accepted_translations",           default: 0
    t.integer  "rejected_translations",           default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tr8n_translator_reports", id: false, force: true do |t|
    t.integer  "id",            default: "nextval('tr8n_translator_reports_id_seq'::regclass)", null: false
    t.integer  "translator_id"
    t.string   "state"
    t.integer  "object_id"
    t.string   "object_type"
    t.string   "reason"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tr8n_translators", id: false, force: true do |t|
    t.integer  "id",                   default: "nextval('tr8n_translators_id_seq'::regclass)", null: false
    t.integer  "user_id",                                                                       null: false
    t.boolean  "inline_mode",          default: false
    t.boolean  "blocked",              default: false
    t.boolean  "reported",             default: false
    t.integer  "fallback_language_id"
    t.integer  "rank",                 default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "gender"
    t.string   "email"
    t.string   "password"
    t.string   "mugshot"
    t.string   "link"
    t.string   "locale"
    t.integer  "level",                default: 0
    t.boolean  "manager"
    t.string   "last_ip"
    t.string   "country_code"
    t.integer  "remote_id"
  end

  create_table "unsubscribes", id: false, force: true do |t|
    t.integer  "id",                          default: "nextval('unsubscribes_id_seq'::regclass)", null: false
    t.integer  "user_id"
    t.string   "email"
    t.text     "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_comments_subscribed",      default: false
    t.boolean  "is_point_changes_subscribed", default: false
    t.boolean  "is_messages_subscribed",      default: false
    t.boolean  "is_followers_subscribed",     default: true
    t.boolean  "is_finished_subscribed",      default: true
    t.boolean  "is_admin_subscribed",         default: false
    t.boolean  "is_idea_changes_subscribed",  default: false
  end

  create_table "user_charts", id: false, force: true do |t|
    t.integer  "id",           default: "nextval('user_charts_id_seq'::regclass)", null: false
    t.integer  "user_id"
    t.integer  "date_year"
    t.integer  "date_month"
    t.integer  "date_day"
    t.integer  "position"
    t.integer  "up_count"
    t.integer  "down_count"
    t.integer  "volume_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_contacts", id: false, force: true do |t|
    t.integer  "id",                          default: "nextval('user_contacts_id_seq'::regclass)", null: false
    t.integer  "user_id"
    t.integer  "other_user_id"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "following_id"
    t.integer  "facebook_uid"
    t.datetime "sent_at"
    t.datetime "accepted_at"
    t.boolean  "is_from_realname",            default: false
    t.string   "status",           limit: 30
  end

  create_table "user_rankings", id: false, force: true do |t|
    t.integer  "id",             default: "nextval('user_rankings_id_seq'::regclass)", null: false
    t.integer  "user_id"
    t.integer  "version",        default: 0
    t.integer  "position"
    t.integer  "capitals_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", id: false, force: true do |t|
    t.integer  "id",                                                                default: "nextval('users_id_seq'::regclass)", null: false
    t.string   "login",                        limit: 40
    t.string   "email",                        limit: 100
    t.string   "old_crypted_password",         limit: 40
    t.string   "old_salt",                     limit: 40
    t.string   "first_name",                   limit: 100
    t.string   "last_name",                    limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "activated_at"
    t.integer  "picture_id"
    t.string   "status",                       limit: 30,                           default: "pending"
    t.integer  "sub_instance_id"
    t.datetime "removed_at"
    t.string   "zip",                          limit: 10
    t.date     "birth_date"
    t.string   "twitter_login",                limit: 15
    t.string   "website",                      limit: 150
    t.boolean  "is_mergeable",                                                      default: true
    t.integer  "referral_id"
    t.boolean  "is_subscribed",                                                     default: true
    t.string   "user_agent",                   limit: 200
    t.string   "referrer",                     limit: 200
    t.boolean  "is_comments_subscribed",                                            default: true
    t.boolean  "is_tagger",                                                         default: false
    t.integer  "endorsements_count",                                                default: 0
    t.integer  "up_endorsements_count",                                             default: 0
    t.integer  "down_endorsements_count",                                           default: 0
    t.integer  "up_issues_count",                                                   default: 0
    t.integer  "down_issues_count",                                                 default: 0
    t.integer  "comments_count",                                                    default: 0
    t.decimal  "score",                                    precision: 11, scale: 0, default: 0
    t.boolean  "is_point_changes_subscribed",                                       default: true
    t.boolean  "is_messages_subscribed",                                            default: true
    t.integer  "capitals_count",                                                    default: 0
    t.integer  "twitter_count",                                                     default: 0
    t.integer  "followers_count",                                                   default: 0
    t.integer  "followings_count",                                                  default: 0
    t.integer  "ignorers_count",                                                    default: 0
    t.integer  "ignorings_count",                                                   default: 0
    t.integer  "position_24hr",                                                     default: 0
    t.integer  "position_7days",                                                    default: 0
    t.integer  "position_30days",                                                   default: 0
    t.integer  "position_24hr_delta",                                               default: 0
    t.integer  "position_7days_delta",                                              default: 0
    t.integer  "position_30days_delta",                                             default: 0
    t.integer  "position",                                                          default: 0
    t.boolean  "is_followers_subscribed",                                           default: true
    t.integer  "sub_instance_referral_id"
    t.integer  "ads_count",                                                         default: 0
    t.integer  "changes_count",                                                     default: 0
    t.string   "google_token",                 limit: 30
    t.integer  "top_endorsement_id"
    t.boolean  "is_finished_subscribed",                                            default: true
    t.integer  "contacts_count",                                                    default: 0
    t.integer  "contacts_members_count",                                            default: 0
    t.integer  "contacts_invited_count",                                            default: 0
    t.integer  "contacts_not_invited_count",                                        default: 0
    t.datetime "google_crawled_at"
    t.integer  "facebook_uid",                 limit: 8
    t.string   "city",                         limit: 80
    t.string   "state",                        limit: 50
    t.integer  "points_count",                                                      default: 0
    t.decimal  "index_24hr_delta",                         precision: 11, scale: 0, default: 0
    t.decimal  "index_7days_delta",                        precision: 11, scale: 0, default: 0
    t.decimal  "index_30days_delta",                       precision: 11, scale: 0, default: 0
    t.integer  "received_notifications_count",                                      default: 0
    t.integer  "unread_notifications_count",                                        default: 0
    t.string   "rss_code",                     limit: 40
    t.integer  "point_revisions_count",                                             default: 0
    t.integer  "qualities_count",                                                   default: 0
    t.string   "address",                      limit: 100
    t.integer  "warnings_count",                                                    default: 0
    t.datetime "probation_at"
    t.datetime "suspended_at"
    t.integer  "referrals_count",                                                   default: 0
    t.boolean  "is_admin",                                                          default: false
    t.integer  "twitter_id"
    t.string   "twitter_token",                limit: 64
    t.string   "twitter_secret",               limit: 64
    t.datetime "twitter_crawled_at"
    t.boolean  "is_admin_subscribed",                                               default: true
    t.string   "buddy_icon_file_name"
    t.string   "buddy_icon_content_type",      limit: 30
    t.integer  "buddy_icon_file_size"
    t.datetime "buddy_icon_updated_at"
    t.boolean  "is_importing_contacts",                                             default: false
    t.integer  "imported_contacts_count",                                           default: 0
    t.boolean  "reports_enabled",                                                   default: false
    t.boolean  "reports_discussions",                                               default: false
    t.integer  "reports_interval"
    t.datetime "last_sent_report"
    t.string   "geoblocking_open_countries",                                        default: ""
    t.string   "identifier_url"
    t.string   "age_group"
    t.string   "post_code"
    t.string   "my_gender"
    t.integer  "report_frequency",                                                  default: 2
    t.boolean  "is_capital_subscribed",                                             default: true
    t.integer  "idea_revisions_count",                                              default: 0
    t.boolean  "is_idea_changes_subscribed",                                        default: false
    t.string   "encrypted_password",                                                default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                                     default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "has_accepted_eula",                                                 default: false
    t.string   "ssn"
    t.string   "company"
    t.boolean  "is_root",                                                           default: false
    t.integer  "account_id"
    t.string   "invitation_token",             limit: 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "last_locale"
    t.string   "paymill_id"
    t.string   "twitter_profile_image_url"
  end

  create_table "viewed_ideas", id: false, force: true do |t|
    t.integer "id",              default: "nextval('viewed_ideas_id_seq'::regclass)", null: false
    t.integer "idea_id"
    t.integer "user_id"
    t.integer "sub_instance_id"
  end

  create_table "web_page_types", force: true do |t|
    t.string   "name"
    t.integer  "weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "web_page_types", ["name"], name: "index_web_page_types_on_name", using: :btree

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
    t.integer  "web_page_type_id"
    t.text     "main_text"
  end

  add_index "web_pages", ["title"], name: "index_web_pages_on_title", using: :btree
  add_index "web_pages", ["url"], name: "index_web_pages_on_url", using: :btree

  create_table "wf_filters", id: false, force: true do |t|
    t.integer  "id",               default: "nextval('wf_filters_id_seq'::regclass)", null: false
    t.string   "type"
    t.string   "name"
    t.text     "data"
    t.integer  "user_id"
    t.string   "model_class_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "widgets", id: false, force: true do |t|
    t.integer  "id",              default: "nextval('widgets_id_seq'::regclass)", null: false
    t.integer  "user_id"
    t.string   "tag_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.integer  "number",          default: 5
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "will_filter_filters", id: false, force: true do |t|
    t.integer  "id",               default: "nextval('will_filter_filters_id_seq'::regclass)", null: false
    t.string   "type"
    t.string   "name"
    t.text     "data"
    t.integer  "user_id"
    t.string   "model_class_name"
    t.datetime "created_at",                                                                   null: false
    t.datetime "updated_at",                                                                   null: false
  end

end
