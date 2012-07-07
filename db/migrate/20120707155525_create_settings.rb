class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string    "key",        :null => false  # Site key (how the site finds this setting)
      t.string    "value"       # The value

      t.enum      "area",       :limit => [:general, :content, :media, :tools, :privacy, :linking, :users, :taxonomy], :default => :general

      t.string    "label",      :null => false  # Form label when asking about this value
      t.enum      "element",    :limit => [:text,:textarea,:checkbox,:radiobutton], :null => false, :default => :text
      t.text      "description" # Help text below the form input
      t.text      "values"      # List of values | delimited
      t.timestamps
    end
    add_index :settings, :key, :unique => true


    puts "-- seeding_data(:settings)"

    settings = [
        {'key' => 'maintenance', 'value' => '-1', 'area' => :general, 'label' => 'Maintenance Mode', 'element' => :checkbox, 'description' => 'Put the site in a maintenance mode', 'values' => ''},
        {'key' => 'title', 'value' => 'Site Title', 'area' => :general, 'label' => 'Site Title', 'element' => :text, 'description' => '', 'values' => ''},
        {'key' => 'tagline', 'value' => 'Thanks for visiting my blog!', 'area' => :general, 'label' => 'Tagline', 'element' => :text, 'description' => '', 'values' => ''},
        {'key' => 'url', 'value' => 'http://randomstringofwords.com', 'area' => :general, 'label' => 'Site Address (URL)', 'element' => :text, 'description' => '', 'values' => ''},
        {'key' => 'email', 'value' => '', 'area' => :general, 'label' => 'Admin Email Address', 'element' => :text, 'description' => 'This address is used as the from address for notification emails and general site contact.', 'values' => ''},
    ]

    settings.each do |as|
      s = Setting.new :value => as['value']
      s.key         = as['key']
      s.label       = as['label']
      s.area        = as['area']
      s.element     = as['element']
      s.description = as['description']
      s.values      = as['values']
      s.save
    end

  end
end
