class CreateContentTaxonomiesPivot < ActiveRecord::Migration
  def change
    create_table :contents_taxonomies, :id => false do |t|
      t.references :content
      t.references :taxonomy
    end
  end
end
