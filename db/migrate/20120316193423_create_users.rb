class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string "first_name", :limit => 25
      t.string "last_name", :limit => 50
      t.string "display_name"
      t.string "url"
      t.string "email", :null => false
      t.string "password", :limit => 40, :null => false
      t.string "salt", :limit=> 40, :null => false
      t.boolean "admin", :default => false, :null => false
      t.timestamps
    end
  end
end
