class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user, :null => false      # User who posted
      t.references :post                      # Parent post if not a post
      t.string    "token", :null => false     # A web safe uuid token for internal reference
      t.text      "content"                   # Text blob
      t.string    "seo_url"                   # Perma link to this object
      t.string    "password", :limit => 40    # PW if set
      t.enum      "type", :limit => [:post, :page, :comment, :message, :ad], :default => :post # Type of object
      t.enum      "style", :limit => [:standard, :notice, :success, :error], :default => :standard
      t.enum      "state", :limit => [:draft, :published, :frozen], :default => :draft # published, draft, whatever
      t.boolean   "allow_comments", :default => true # are comments on this thing allowed?
      t.boolean   "is_sticky", :default => false # keep at top of matched listing?
      t.boolean   "is_closable", :default => false # is this panel closable in a list?
      t.datetime  "go_live", :null => false   # Go live date
      t.datetime  "go_dead"                   # Go dead date
      t.timestamps
    end
    add_index("posts", "user_id")
    add_index("posts", "post_id")
    add_index("posts", "seo_url")
  end
end
