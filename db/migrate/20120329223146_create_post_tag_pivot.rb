class CreatePostTagPivot < ActiveRecord::Migration
  def up
    create_table :posts_tags, :id => false do |t|
      t.references :post
      t.references :tag
    end
  end

  def down
    drop_table :posts_tags
  end
end
