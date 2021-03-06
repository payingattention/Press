require 'model_helper'

class Content < ActiveRecord::Base

  # Mass assignable fields
  attr_accessible :layout_id, :text, :seo_url, :password, :format, :style, :state, :allow_comments, :is_sticky, :is_closable, :is_indexable, :is_searchable, :is_frontable, :go_live, :go_dead

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

  # Before we send to validation do any other preprocessing needed
  before_validation :preprocess

  # Add validation
  validates :go_live, :presence => true
  validates :seo_url, :presence => { :message => "SEO Url can't be blank" }
  validates :seo_url, :uniqueness => { :message => "It appears the SEO Url that you entered is already in use by another piece of content" }

  # Backup this sucker on create or update
  after_create :backup, :on => :create
  after_update :backup, :on => :update
  # Purge the backup on destroy
  after_destroy :purge, :on => :destroy
  # Get the original seo_url
  after_initialize do
    self.original_seo_url = self.seo_url
  end
  # This is the old seo_url
  attr_accessor :original_seo_url

  # Storage for the "parts" of a content
  @_header = nil
  @_body = nil
  @_tease = nil

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

  # Comments
  # For now all child content is a "comment" though it may not be
  def comments
    contents.all
  end

  # Belongs to any taxonomy kind with id?
  def has_taxonomy? taxonomy_id
    taxonomies.all(:conditions => { :id => taxonomy_id }).present?
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
    self.seo_url = ModelHelper::strip_seo_url self.seo_url
  end

  # After all is said and done .. do stuff
  def backup
    ModelHelper::backup self
  end

  # After we have destroyed .. do stuff
  def purge
    ModelHelper::destroy_backup self
  end

end
