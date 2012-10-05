class CreateLayouts < ActiveRecord::Migration
  def change
    create_table :layouts do |t|

      t.string    "title",        :null => false                    # title of layout
      t.text      "description",  :null => false
      t.boolean   "is_deletable", :null => false, :default => true  # is this one of the core layouts?

      t.timestamps
    end
  end
end
