class Post < ActiveRecord::Base

  # Posts ( pages, comments, messages, ads etc.. ) must belong to a user
  belongs_to :user

  # A Taxonomy is a keyword (letter, number, word, paragraph, icon..whatever) that is designed to provide some sort
  # of identifier that itself has a classification in order to better organize things.
  # Posts can have many different identifiers such as Tags, and Categories.  More over those taxonomies also reference
  # back to the things they contain.
  has_and_belongs_to_many :taxonomies

  # A post may contain other posts, as a "post" is just a container for some form of blob text with associated data.
  # Posts (content) can be "posts", "pages", "comments", "messages", "ads"..etc.
  has_many :posts

  # Before we create our post, generate a unique token id for it that can be used for reference if needed
  before_validation :generate_token, :on => :create

  # Add validation
  validates :token,   :presence => true
  validates :go_live, :presence => true
  validates :seo_url, :presence => { :message => "SEO Url can't be blank for Posts" }, :if => :is_a_post?
  validates :seo_url, :presence => { :message => "SEO Url can't be blank for Pages" }, :if => :is_a_page?
  validates :seo_url, :uniqueness => { :message => "It appears the SEO Url that you entered is already in use by another post or page" }, :if => :is_a_post? || :is_a_page?

  # Define some scoped helpers
  scope :ads, where(:object_type => :ad)
  scope :posts, where(:object_type => :post)
  scope :pages, where(:object_type => :page)
  scope :comments, where(:object_type => :comment)
  scope :messages, where(:object_type => :message)

  # Generate a unique token and make sure its unique by testing for it
  def generate_token
    begin
      token = SecureRandom.urlsafe_base64
    end while Post.where(:token => token).exists?
    self.token = token
  end

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

  # Belongs to any taxonomy type with id?
  def has_taxonomy? taxonomy_id
    taxonomies.all(:conditions => { :id => taxonomy_id }).present?
  end

  # Is this a post?
  def is_a_post?
    self.object_type == :post
  end

  # is this a page?
  def is_a_page?
    self.object_type == :page
  end

end
