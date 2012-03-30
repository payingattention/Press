class Post < ActiveRecord::Base

  belongs_to :user
  has_and_belongs_to_many :taxonomies

  def tags
    taxonomies.all :conditions => { :classification => :tag }
  end

  def categories
    taxonomies.all :conditions => { :classification => :category }
  end

end
