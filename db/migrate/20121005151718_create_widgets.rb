class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|

      t.string    "title",        :null => false                    # the pretty title of this widget
      t.string    "token",        :null => false                    # how is this widget referenced
      t.text      "description",  :null => false                    # whats this thing do?
      t.text      "code",         :null => false                    # code that makes it happen
      t.timestamps
    end
  end
end
