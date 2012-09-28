class Post < ActiveRecord::Base

  # Posts ( pages, comments, messages, ads etc.. ) must belong to a user
  belongs_to :user

  # A Taxonomy is a keyword (letter, number, word, paragraph, icon..whatever) that is designed to provide some sort
  # of identifier that itself has a classification in order to better organize things.
  # Posts can have many different identifiers such as Tags, and Categories.  More over those taxonomies also reference
  # back to the things they contain.
  has_and_belongs_to_many :taxonomies

  # A post may contain other posts as a "post" is just a container for some form of blob text with associated data.
  # Posts can be "posts", "pages", "comments", "messages"..etc.
  has_many :posts

  # Add validation
  validates :go_live, :presence => true

  # Active Record Callbacks
  before_validation(:on => :create) do
    self.go_live = DateTime.now unless self.go_live.present?
  end

  # Define some scoped helpers
  scope :ads, where(:object_type => :ad)
  scope :posts, where(:object_type => :post)
  scope :pages, where(:object_type => :page)
  scope :comments, where(:object_type => :comment)
  scope :messages, where(:object_type => :message)

  # Tags ( Taxonomies with a classification of tag )
  # post.tags returns all child taxonomies that are tags
  def tags
    taxonomies.all :conditions => { :classification => :tag }
  end

  # Categories ( Taxonomies with a classification of category )
  # post.categories returns all child taxonomies that are categories
  def categories
    taxonomies.all :conditions => { :classification => :category }
  end

  # Comments ( Posts with an object type of comment )
  # post.comments returns all child posts that are comments
  def comments
    posts.all :conditions => { :object_type => :comment }
  end

  # Parse Content goes through the newly created object and pulls out the title, seo etc and sets
  # the object before validation happens and before we save.

end
