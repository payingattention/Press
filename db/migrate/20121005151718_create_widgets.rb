class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|

      t.references :widget                          # Parent widget if this is a child
      t.string    "title",        :null => false    # the pretty title of this widget
      t.string    "token",        :null => false    # how is this widget referenced
      t.text      "description",  :null => false    # whats this thing do?
      t.text      "code",         :null => false    # code that makes it happen
      t.boolean   "is_droppable", :null => false, :default => false # Can this widget have child widgets?
      t.boolean   "is_deletable", :null => false, :default => true  # is this one of the core widgets?

      t.timestamps
    end

    add_index("widgets", "widget_id")
    add_index("widgets", "token")

  end
end
