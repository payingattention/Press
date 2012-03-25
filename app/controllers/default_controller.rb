class DefaultController < ApplicationController

  layout 'application'

  # Show the front page!
  def index
    # Get the 6 latest -- TODO this should be configurable
    limit = 6;
    # Our page number
    page = (params[:page].to_i - 1) || 1
    # Our filter if there is one set
    @filter = params[:filter] || ''

    # Get the latest posts by go_live
    @posts = Post.order('go_live DESC')
    # Make sure we are only getting those that are published
    @posts = @posts.where( :state => :published )
    # Make sure we are talking about posts or messages
    t = Post.arel_table
    @posts = @posts.where( t[:object_type].matches(:post).or(t[:object_type].matches(:message)))
    # Make sure they don't have a password.. those are "private"
    @posts = @posts.where( :password => nil )
    # If a filter is set, use it
    @posts = @posts.where(["title like ? or content like ?", '%'+@filter+'%', '%'+@filter+'%'] ) if @filter.present?
    # Limit the number of posts to show
    @posts = @posts.limit(limit)
    # Set the offset if we aren't on the first page.
    @posts = @posts.offset(limit.to_i * page.to_i) if page > 0
    # Need this to show a previous/next button
    @pagination_current_page = (page.to_i + 1) > 0 ? (page.to_i + 1) : 1

  end


  # Show a post or page, based on the SEO Url
  def show
    #load the post or page by seo url or return to index if not found
    @post = Post.find_by_seo_url params[:seo_url]
    unless @post.present?
      redirect_to :action => 'index'
    end

  end

end
