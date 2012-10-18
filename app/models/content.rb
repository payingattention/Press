require 'model_helper'

class Content < ActiveRecord::Base

  # Mass assignable fields
  attr_accessible :layout_id, :text, :seo_url, :password, :kind, :format, :style, :state, :allow_comments, :is_sticky, :is_closable, :is_indexable, :is_searchable, :is_frontable, :go_live, :go_dead

  # Contents ( posts, pages, comments, messages, ads etc.. ) must belong to a user
  belongs_to :user

  # A Taxonomy is a keyword (letter, number, word, paragraph, icon..whatever) that is designed to provide some sort
  # of identifier that itself has a classification in order to better organize things.
  # Contents can have many different identifiers such as Tags, and Categories.  More over those taxonomies also reference
  # back to the things they contain.
  has_and_belongs_to_many :taxonomies

  # A content may contain other contents, as a "content" is just a container for some form of blob text with associated data.
  # Contents (content) can be "posts", "pages", "comments", "messages", "ads"..etc.
  has_many :contents

  has_many :media

  # A piece of content belongs to a single layout that will be used to determine how to show that content.
  belongs_to :layout

  # Before we create our content, generate a unique token id for it that can be used for reference if needed
  before_validation :generate_token, :on => :create
  # Before we send to validation do any other preprocessing needed
  before_validation :preprocess

  # Add validation
  validates :token,   :presence => true
  validates :go_live, :presence => true
  validates :seo_url, :presence => { :message => "SEO Url can't be blank for Posts" }, :if => :is_a_post?
  validates :seo_url, :presence => { :message => "SEO Url can't be blank for Pages" }, :if => :is_a_page?
  validates :seo_url, :uniqueness => { :message => "It appears the SEO Url that you entered is already in use by another post or page" }, :if => :is_a_post? || :is_a_page?

  # After we have commit and saved, fire off any post processing commands
  after_commit :postprocess

  # Define some scoped helpers
  scope :ads, where(:kind => :ad)
  scope :posts, where(:kind => :post)
  scope :pages, where(:kind => :page)
  scope :blocks, where(:kind => :block)
  scope :comments, where(:kind => :comment)
  scope :messages, where(:kind => :message)

  # Storage for the "parts" of a content
  @_header = nil
  @_body = nil
  @_tease = nil

  # Generate a unique token and make sure its unique by testing for it
  def generate_token
    begin
      token = SecureRandom.urlsafe_base64
    end while Content.where(:token => token).exists?
    self.token = token
  end

  # Tags ( Taxonomies with a classification of tag )
  # content.tags returns all child taxonomies that are tags
  def tags
    taxonomies.all :conditions => { :classification => :tag }
  end

  # Categories ( Taxonomies with a classification of category )
  # content.categories returns all child taxonomies that are categories
  def categories
    taxonomies.all :conditions => { :classification => :category }
  end

  # Comments ( Contents with an object kind of comment )
  # content.comments returns all child contents that are comments
  def comments
    contents.all :conditions => { :kind => :comment }
  end

  # Belongs to any taxonomy kind with id?
  def has_taxonomy? taxonomy_id
    taxonomies.all(:conditions => { :id => taxonomy_id }).present?
  end

  # Is this a post?
  def is_a_post?
    self.kind == :post
  end

  # is this a page?
  def is_a_page?
    self.kind == :page
  end

  # Return the body of the content
  def body
    parse unless @_body.present?
    @_body
  end

  # Return the header of the content
  def header query = nil
    parse unless @_header.present?
    @_header
  end

  # Return the tease of the content
  def tease
    parse unless @_tease.present?
    @_tease
  end

  private

  # Parse out the header, tease and body of the content
  def parse
    @_header, @_body = text.split(/-\s-\s-/,2)
    @_header, @_tease = @_header.split(/\*\s\*\s\*/,2)
    @_tease = '' unless @_tease.present?
    @_body = '' unless @_body.present?
  end

  # Before validation preprocessing
  def preprocess
    self.seo_url = self.name unless self.seo_url.present?
    self.seo_url = ModelHelper::strip_seo_url self.seo_url
  end

  # After all is said and done .. do stuff
  def postprocess
    ModelHelper::backup 'content', self.seo_url, self
  end

end
