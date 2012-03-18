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

ActiveRecord::Schema.define(:version => 20120316202312) do

  create_table "posts", :force => true do |t|
    t.integer  "user_id",                                                                               :null => false
    t.integer  "post_id"
    t.text     "content"
    t.string   "title"
    t.string   "seo_url"
    t.string   "password",       :limit => 40
    t.enum     "object_type",    :limit => [:post, :page, :comment, :message, :ad], :default => :post
    t.enum     "state",          :limit => [:draft, :published, :frozen],           :default => :draft
    t.boolean  "allow_comments",                                                    :default => true
    t.boolean  "is_sticky",                                                         :default => false
    t.datetime "go_live",                                                                               :null => false
    t.datetime "go_dead"
    t.datetime "created_at",                                                                            :null => false
    t.datetime "updated_at",                                                                            :null => false
  end

  add_index "posts", ["seo_url"], :name => "index_posts_on_seo_url"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "first_name",   :limit => 25
    t.string   "last_name",    :limit => 50
    t.string   "display_name"
    t.string   "url"
    t.string   "email",                                         :null => false
    t.string   "password",     :limit => 40,                    :null => false
    t.string   "salt",         :limit => 40,                    :null => false
    t.boolean  "admin",                      :default => false, :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

end
