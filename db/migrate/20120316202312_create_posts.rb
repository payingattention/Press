class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user, :null => false
      t.references :post
      t.text      "content"
      t.string    "title"
      t.string    "seo_url"
      t.string    "password", :limit => 40
      t.string    "type", :limit => 20
      t.datetime  "go_live"
      t.datetime  "go_dead"
      t.timestamps
    end
    add_index("posts", "user_id")
    add_index("posts", "seo_url")
  end
end
