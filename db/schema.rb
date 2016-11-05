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

ActiveRecord::Schema.define(version: 20161105191329) do

  create_table "clients", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "first_name",             default: ""
    t.string   "last_name",              default: ""
    t.text     "location"
    t.string   "auth_token",             default: ""
    t.boolean  "admin",                  default: false
  end

  add_index "clients", ["email"], name: "index_clients_on_email", unique: true
  add_index "clients", ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true

  create_table "requests", force: :cascade do |t|
    t.integer  "bedrooms",        default: 0
    t.integer  "bathrooms",       default: 0
    t.integer  "living_rooms"
    t.integer  "kitchens",        default: 0
    t.datetime "time_of_arrival"
    t.text     "schedule"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "client_id"
  end

  add_index "requests", ["client_id"], name: "index_requests_on_client_id"

  create_table "requests_workers", id: false, force: :cascade do |t|
    t.integer "request_id", null: false
    t.integer "worker_id",  null: false
  end

  add_index "requests_workers", ["request_id", "worker_id"], name: "index_requests_workers_on_request_id_and_worker_id"
  add_index "requests_workers", ["worker_id", "request_id"], name: "index_requests_workers_on_worker_id_and_request_id"

  create_table "workers", force: :cascade do |t|
    t.string   "first_name",      default: ""
    t.string   "last_name",       default: ""
    t.integer  "age",             default: 0
    t.string   "sex",             default: ""
    t.string   "phone_number",    default: ""
    t.text     "location",        default: ""
    t.text     "experience",      default: ""
    t.decimal  "min_wage",        default: 0.0
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "email",           default: ""
    t.string   "password_digest"
    t.string   "auth_token"
  end

end
