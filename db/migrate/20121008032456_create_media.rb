class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|

      t.references  :content
      t.string      "file"

      t.timestamps
    end
  end
end
