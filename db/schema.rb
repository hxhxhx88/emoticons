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

ActiveRecord::Schema.define(version: 20160714084305) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "pg_trgm"

  create_table "addresses", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "location"
    t.string   "phone"
    t.string   "name"
    t.string   "zip_code"
    t.boolean  "default"
    t.uuid     "developer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "administrators", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "real_name"
    t.uuid   "user_id"
  end

  create_table "api_counters", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "app_id"
    t.string   "method"
    t.datetime "timestamp"
    t.integer  "count"
  end

  create_table "app_configs", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "default_packages",  array: true
    t.uuid     "default_emoticons", array: true
    t.uuid     "app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_customs", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "app_id"
    t.string   "tag_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "weight",     default: 0
  end

  create_table "applications", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.string   "access_key"
    t.string   "secret_key"
    t.string   "reset_code"
    t.datetime "reset_code_expire"
    t.string   "view_code"
    t.datetime "view_code_expire"
    t.uuid     "developer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "app_type"
    t.string   "description"
    t.uuid     "icon_id"
    t.boolean  "disable",           default: false
  end

  create_table "audit_records", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "target_id",   null: false
    t.string   "type"
    t.boolean  "pass"
    t.string   "message"
    t.uuid     "operator_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "email"
    t.boolean  "email_confirm"
    t.string   "password_digest"
    t.string   "confirm_code"
    t.string   "phone"
    t.string   "id_number"
    t.uuid     "id_card_front"
    t.uuid     "id_card_back"
    t.string   "real_name"
    t.string   "sms_code"
    t.boolean  "phone_confirm"
    t.integer  "sms_last_send"
    t.integer  "account_status"
    t.string   "account_reject_reason"
    t.string   "name"
    t.uuid     "avatar"
    t.uuid     "home_banner"
    t.string   "description"
    t.integer  "author_status"
    t.string   "author_reject_reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reset_token"
    t.datetime "reset_token_expire"
  end

  create_table "balances", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "type"
    t.integer  "amount"
    t.uuid     "developer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bills", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "developer_id"
    t.date     "start"
    t.date     "end"
    t.string   "type"
    t.integer  "state"
    t.integer  "amount"
    t.integer  "traffic_count", limit: 8
    t.integer  "get_usage"
    t.integer  "other_usage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupons", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "sn"
    t.boolean  "active"
    t.uuid     "developer_id"
    t.integer  "amount"
    t.boolean  "binding"
    t.datetime "expire_at"
    t.datetime "active_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  add_index "coupons", ["sn"], name: "index_coupons_on_sn", using: :btree

  create_table "data_stats", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "app_id"
    t.uuid     "content_id"
    t.string   "content_type"
    t.string   "action"
    t.datetime "timestamp"
    t.integer  "count"
  end

  add_index "data_stats", ["timestamp"], name: "index_data_stats_on_timestamp", using: :btree

  create_table "developers", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "email"
    t.string   "phone"
    t.string   "password_digest"
    t.boolean  "confirm"
    t.string   "state"
    t.string   "confirm_code"
    t.string   "address"
    t.string   "qq"
    t.string   "personal_id"
    t.string   "real_name"
    t.string   "phone_check"
    t.boolean  "is_org"
    t.string   "org_name"
    t.string   "org_site"
    t.uuid     "org_license_id"
    t.uuid     "profile_id"
    t.uuid     "profile_back_id"
    t.datetime "phone_check_code_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reject_reason"
    t.string   "reset_code"
    t.datetime "reset_code_validation"
    t.integer  "status",                default: 0
  end

  create_table "emoticons", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "description"
    t.integer  "collect"
    t.integer  "share"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "image_id"
    t.uuid     "thumb_id"
    t.integer  "thumb_up",    default: 0
  end

  create_table "emoticons_tags", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "emoticon_id"
    t.uuid     "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "emoticons_tags", ["tag_id", "emoticon_id"], name: "emoticons_tags_ids_idx", unique: true, using: :btree

  create_table "images", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "key"
    t.integer  "fsize"
    t.integer  "height"
    t.integer  "width"
    t.string   "format"
    t.string   "md5"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "invoices", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "developer_id"
    t.string   "address"
    t.integer  "state"
    t.string   "title"
    t.integer  "amount"
    t.string   "express_id"
    t.string   "express_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "release_at"
  end

  create_table "json_caches", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.json     "content"
    t.datetime "expire"
  end

  create_table "lists", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.uuid     "contents",                    array: true
    t.uuid     "cover"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.boolean  "enable"
    t.uuid     "user_id"
    t.uuid     "fork_from"
    t.uuid     "author_id"
    t.string   "description"
    t.string   "sub_title"
    t.uuid     "background"
    t.integer  "weight"
    t.string   "tag_description"
    t.integer  "status"
    t.string   "copyright"
    t.datetime "audit_at"
    t.datetime "pass_at"
    t.integer  "price",           default: 0
  end

  create_table "package_tags", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "package_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "weight",     default: 0
  end

  create_table "purchases", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.integer  "amount"
    t.string   "type"
    t.string   "description"
    t.uuid     "developer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "consumption_type"
    t.string   "ch_id"
    t.integer  "status",           default: 0
    t.string   "order_no"
  end

  create_table "recommends", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.json     "contents"
    t.datetime "publish_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enable"
  end

  create_table "sub_bills", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "bill_id"
    t.string   "type"
    t.integer  "amount"
    t.integer  "count",      limit: 8
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag_types", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tag_types", ["name"], name: "index_tag_types_on_name", using: :btree

  create_table "tags", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "tag_type_id"
    t.integer  "weight"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree
  add_index "tags", ["name"], name: "tag_trgm", using: :gist

  create_table "traffic_statistics", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.integer  "count",     limit: 8
    t.uuid     "app_id"
    t.datetime "timestamp"
  end

  create_table "upload_records", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id"
    t.uuid     "image_id"
    t.datetime "created_at"
  end

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "contents",   array: true
    t.uuid     "app_id"
    t.string   "auth_token"
    t.integer  "role_mask"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
