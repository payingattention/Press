class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string    "key"         # Site key (how the site finds this setting)
      t.string    "value"       # The value

      t.enum      "area",       :limit => [:general, :content, :media, :tools, :privacy, :linking, :users, :taxonomy], :default => :general

      t.string    "label"       # Form label when asking about this value
      t.enum      "element",    :limit => [:text,:textarea,:checkbox,:radiobutton]
      t.text      "description" # Help text below the form input
      t.text      "values"      # List of values | delimited
      t.timestamps
    end
    add_index :settings, :key, :unique => true
  end
end
