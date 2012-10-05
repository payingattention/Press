class Widget < ActiveRecord::Base
  attr_accessible :title, :token, :description, :code

  # A layout is a wrapper object that describes how a page should be rendered.
  has_and_belongs_to_many :layouts

  # A widget may contain other widgets
  has_many :widgets

end
