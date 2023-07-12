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

ActiveRecord::Schema[7.0].define(version: 2023_07_11_230139) do
  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "status", default: "active", null: false
    t.boolean "admin", default: false, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_merchants_on_email", unique: true
    t.index ["status"], name: "index_merchants_on_status"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "type", null: false
    t.string "uuid", null: false
    t.decimal "amount", precision: 14, scale: 2
    t.string "status", null: false
    t.integer "merchant_id", null: false
    t.string "customer_email"
    t.string "customer_phone"
    t.string "notification_url"
    t.string "parent_transaction_type"
    t.integer "parent_transaction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_transaction_type", "parent_transaction_id"], name: "index_transactions_on_parent_transaction"
    t.index ["status"], name: "index_transactions_on_status"
    t.index ["uuid"], name: "index_transactions_on_uuid", unique: true
  end

end
