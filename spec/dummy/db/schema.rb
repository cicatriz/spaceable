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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120208000642) do

  create_table "components", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "memories", :force => true do |t|
    t.integer  "learner_id"
    t.string   "learner_type"
    t.integer  "component_id"
    t.string   "component_type"
    t.decimal  "ease",           :default => 2.5
    t.decimal  "interval",       :default => 1.0
    t.integer  "views",          :default => 0
    t.integer  "streak",         :default => 0
    t.datetime "last_viewed"
    t.datetime "due"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "memories", ["component_id"], :name => "index_memories_on_component_id"
  add_index "memories", ["learner_id", "component_id"], :name => "index_memories_on_learner_id_and_component_id", :unique => true
  add_index "memories", ["learner_id"], :name => "index_memories_on_learner_id"

  create_table "memory_ratings", :force => true do |t|
    t.integer  "memory_id"
    t.integer  "quality"
    t.integer  "streak"
    t.decimal  "ease"
    t.integer  "interval"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "memory_ratings", ["memory_id"], :name => "index_memory_ratings_on_memory_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
