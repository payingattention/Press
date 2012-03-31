class DefaultController < ApplicationController

  layout 'application'

  # Show the front page!
  def index
    # Catch old legacy wordpress routing ?p=####
    post = Post.find_by_id params[:p]
    if post.present?
      redirect_to :action => 'show', :seo_url => post.seo_url
    else
      # Most likely this is the way it will always go.. show me the list
      @posts = Post.order
      get_posts

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @posts }
      end
    end

  end

  # Show a post or page, based on the SEO Url
  def show
    #load the post or page by seo url or return to index if not found
    @post = Post.find_by_seo_url params[:seo_url]
    unless @post.present?
      redirect_to :action => 'index'
    end

    @query = params[:query] || ''

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # Index route for Categories -- Basically the same code as index
  def category
    # Whats the last category we are asking for? (the rest don't matter I don't think..)
    requested_category = params[:category].split("/").last
    category = Taxonomy.find_by_seo_url requested_category

    if category.present?
      @category = category
      @posts = category.posts
      get_posts

      respond_to do |format|
        format.html { render :template => 'default/index' }
        format.json { render json: @posts }
      end
    else
      # No such category found, redirect to root index
      redirect_to root_path
    end
  end

  # Index route for Tags
  def tag
    # Whats the last tag we are asking for? (the rest don't matter I don't think..)
    requested_tag = params[:tag].split("/").last
    tag = Taxonomy.find_by_seo_url requested_tag

    if tag.present?
      @tag = tag
      @posts = tag.posts
      get_posts

      respond_to do |format|
        format.html { render :template => 'default/index' }
        format.json { render json: @posts }
      end
    else
      # No such category found, redirect to root index
      redirect_to root_path
    end
  end

  private
  # Paginate and process our requested posts page.. Used by Index, Category and Tag
  def get_posts
    # Get the 6 latest -- TODO this should be configurable
    limit = 6;
    # Our page number
    page = (params[:page].to_i - 1) || 1
    # Our query if there is one set
    @query = params[:query] || ''
    # Get the latest posts by go_live
    @posts = @posts.order('go_live DESC')
    # Make sure we are only getting those that are published
    @posts = @posts.where( :state => :published )
    # Make sure we are talking about posts or messages
    t = Post.arel_table
    @posts = @posts.where( t[:object_type].matches(:post).or(t[:object_type].matches(:message)))
    # Make sure they don't have a password.. those are "private"
    @posts = @posts.where( :password => nil )
    # If a query is set, use it
    @posts = @posts.where(["title like ? or content like ?", '%'+@query+'%', '%'+@query+'%'] ) if @query.present?
    # Limit the number of posts to show
    @posts = @posts.limit(limit)
    # Set the offset if we aren't on the first page.
    @posts = @posts.offset(limit.to_i * page.to_i) if page > 0
    # Need this to show a previous/next button
    @pagination_current_page = (page.to_i + 1) > 0 ? (page.to_i + 1) : 1
  end

end
