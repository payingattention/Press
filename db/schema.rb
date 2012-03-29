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

ActiveRecord::Schema.define(:version => 20120329125606) do

  create_table "admin_tags", :force => true do |t|
    t.string   "name",                                                          :null => false
    t.string   "seo_url",                                                       :null => false
    t.text     "description"
    t.enum     "classification", :limit => [:tag, :category], :default => :tag, :null => false
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
  end

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
    t.string   "display_name",           :limit => 50,                                  :null => false
    t.string   "first_name",             :limit => 50,                                  :null => false
    t.string   "last_name",              :limit => 50,                                  :null => false
    t.enum     "gender",                 :limit => [:male, :female],                    :null => false
    t.datetime "date_of_birth"
    t.boolean  "is_admin",                                           :default => false, :null => false
    t.string   "email",                                              :default => "",    :null => false
    t.string   "encrypted_password",                                 :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
