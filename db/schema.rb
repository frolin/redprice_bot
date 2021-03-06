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

ActiveRecord::Schema.define(version: 2022_02_21_002216) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "menu_items", force: :cascade do |t|
    t.text "name"
    t.integer "position"
    t.string "title"
    t.text "body"
    t.bigint "menu_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["menu_id"], name: "index_menu_items_on_menu_id"
  end

  create_table "menus", force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.string "title"
    t.text "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "products", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.jsonb "data", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "link_data", default: {}
    t.string "sku"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "request_results", force: :cascade do |t|
    t.jsonb "data"
    t.string "title"
    t.bigint "request_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["request_id"], name: "index_request_results_on_request_id"
  end

  create_table "requests", force: :cascade do |t|
    t.jsonb "result", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "price"
    t.bigint "store_id", null: false
    t.index ["store_id"], name: "index_requests_on_store_id"
  end

  create_table "store_requests", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "request_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "result", default: {}
    t.index ["request_id"], name: "index_store_requests_on_request_id"
    t.index ["store_id"], name: "index_store_requests_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.jsonb "config", default: {}
    t.bigint "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.index ["product_id"], name: "index_stores_on_product_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.jsonb "preferences", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "menu_items", "menus"
  add_foreign_key "products", "users"
  add_foreign_key "request_results", "requests"
  add_foreign_key "requests", "stores"
  add_foreign_key "store_requests", "requests"
  add_foreign_key "store_requests", "stores"
end
