class Layout < ActiveRecord::Base
  attr_accessible :title

  # A widget is an individual piece of a layout that gets down to the particulars of how to render something
  has_and_belongs_to_many :widgets

end
