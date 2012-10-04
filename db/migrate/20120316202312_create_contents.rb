class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.references :user, :null => false      # User who posted
      t.references :content                      # Parent post if not a post
      t.string    "token", :null => false     # A web safe uuid token for internal reference
      t.text      "content"                   # Text blob
      t.string    "seo_url"                   # Perma link to this object
      t.string    "password", :limit => 40    # PW if set
      t.enum      "kind", :limit => [:post, :page, :comment, :message, :ad], :default => :post # Type of object
      t.enum      "format", :limit => [:markdown, :html, :csv, :json, :text], :default => :markdown
      t.enum      "style", :limit => [:standard, :featured, :notice, :success, :error, :warning, :borderless], :default => :standard
      t.enum      "state", :limit => [:draft, :published, :frozen], :default => :draft # published, draft, whatever
      t.boolean   "allow_comments", :default => true # are comments on this thing allowed?
      t.boolean   "is_sticky", :default => false # keep at top of matched listing?
      t.boolean   "is_closable", :default => false # is this panel closable in a list?
      t.boolean   "is_indexable", :default => true # is this content included in taxonomy index lists?
      t.boolean   "is_searchable", :default => true # is this content included in site wide search?
      t.boolean   "is_frontable", :default => true # does this content show up on the front page index list?
      t.datetime  "go_live", :null => false   # Go live date
      t.datetime  "go_dead"                   # Go dead date
      t.timestamps
    end
    add_index("contents", "user_id")
    add_index("contents", "content_id")
    add_index("contents", "seo_url")
    add_index("contents", "token")
  end
end
