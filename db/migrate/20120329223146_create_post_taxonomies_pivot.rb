class CreatePostTaxonomiesPivot < ActiveRecord::Migration
  def up
    create_table :posts_taxonomies, :id => false do |t|
      t.references :post
      t.references :taxonomy
    end
  end

  def down
    drop_table :posts_taxonomies
  end
end
