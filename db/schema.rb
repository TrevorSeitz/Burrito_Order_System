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

ActiveRecord::Schema.define(version: 20180618161319) do

  create_table "burritos", force: :cascade do |t|
    t.string  "name"
    t.string  "description"
    t.decimal "price",       precision: 10, scale: 2
    t.integer "quantity"
    t.boolean "vegan"
    t.boolean "gluten_free"
    t.boolean "hot"
  end

  create_table "order_burritos", force: :cascade do |t|
    t.integer "order_id"
    t.integer "user_id"
    t.integer "burrito_id"
    t.integer "quantity"
    t.integer "item_price"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "store_id"
    t.integer "user_id"
    t.decimal "order_total"
    t.integer "total_items"
  end

  create_table "stores", force: :cascade do |t|
    t.string "store_name"
    t.string "address"
    t.string "phone_number"
  end

  create_table "users", force: :cascade do |t|
    t.string  "name"
    t.string  "username"
    t.string  "email"
    t.string  "password_digest"
    t.integer "store_id"
    t.integer "order_ids"
  end

end
