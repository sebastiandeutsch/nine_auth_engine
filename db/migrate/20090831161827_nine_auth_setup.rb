class NineAuthSetup < ActiveRecord::Migration

  def self.up

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "perishable_token",    :default => "",                           :null => false
    t.string   "time_zone",           :default => "Eastern Time (US & Canada)"
    t.boolean  "active",              :default => true
    t.integer  "login_count",         :default => 0,                            :null => false
    t.integer  "failed_login_count",  :default => 0,                            :null => false
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "token"
    t.string   "single_access_token",                                           :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.timestamps
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  
  end
  
  def self.down
    drop_table "users"
  end
  
end