require 'model_helper'

class Taxonomy < ActiveRecord::Base

  # Mass assignable fields
  attr_accessible :name, :seo_url, :description, :classification

  # Add validation
  validates :name,           :presence => true
  validates :seo_url,        :presence => true
  validates :classification, :presence => true

  # A Taxonomy is a keyword (letter, number, word, paragraph, icon..whatever) that is designed to provide some sort
  # of identifier that itself has a classification in order to better organize things.
  # Posts can have many different identifiers such as Tags, and Categories.  More over those taxonomies also reference
  # back to the things they contain.
  has_and_belongs_to_many :contents

  # Before we send to validation, fix the seo_url
  before_validation :preprocess

  # Add validation
  validates :name,    :presence => true
  validates :seo_url, :uniqueness => { :message => "It appears the SEO Url that you entered is already in use" }

  # Define some scoped helpers
  scope :tags, where(:classification => :tag)
  scope :categories, where(:classification => :category)

  # Before validation preprocessing
  def preprocess
    self.seo_url = self.name unless self.seo_url.present?
    self.seo_url = ModelHelper::strip_seo_url self.seo_url
  end

end
