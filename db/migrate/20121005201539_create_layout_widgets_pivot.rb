class CreateLayoutWidgetsPivot < ActiveRecord::Migration
  def change
    create_table :layouts_widgets, :id => false do |t|
      t.references :widget,   :null => false
      t.references :layout,   :null => false
      t.integer    :sequence, :null => false
    end
  end
end
