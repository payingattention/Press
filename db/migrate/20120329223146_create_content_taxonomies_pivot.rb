class CreateContentTaxonomiesPivot < ActiveRecord::Migration
  def change
    create_table :contents_taxonomies, :id => false do |t|
      t.references :content,  :null => false
      t.references :taxonomy, :null => false
    end
  end
end
