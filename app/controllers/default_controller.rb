class DefaultController < ApplicationController

  layout 'application'

  # Show the front page!
  def index
    # Catch old legacy wordpress routing ?p=####
    post = Post.find_by_id params[:p]
    if post.present?
      redirect_to :action => 'show', :seo_url => post.seo_url
    else
      # Okay get me ma'posts
      @posts = PostDecorator.decorate(get_posts Post.order)

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @posts }
      end
    end

  end

  # Show a post or page, based on the SEO Url
  def show
    #load the post or page by seo url or return to index if not found
    @post = PostDecorator.find_by_seo_url params[:seo_url]
    if @post.present?
      @query = params[:query] || ''

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @post }
        format.md { render :template => 'default/show' }
      end
    else
      redirect_to :action => 'index'
    end
  end

  # Index route for Categories -- Basically the same code as index
  def category
    # Whats the last category we are asking for? (the rest don't matter I don't think..)
    requested_category = params[:category].split("/").last
    category = Taxonomy.find_by_seo_url requested_category

    if category.present?
      @posts = PostDecorator.decorate(get_posts category.posts Post.order)

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
      @posts = PostDecorator.decorate(get_posts tag.posts Post.order)

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
  def get_posts posts
    # We'll need this
    t = Post.arel_table
    # Our page number
    page = (params[:page].to_i - 1) || 1
    # Our query if there is one set
    @query = params[:query] || ''

    # Get all the published, frontable sticky posts first
    stickies = Post.order('go_live DESC').where( :state => :published, :is_frontable => true, :is_sticky => true )
    # Make sure they are messages or posts
    stickies = stickies.where( t[:kind].matches(:post).or(t[:kind].matches(:message)) )

    # Get the 6 latest -- TODO this should be configurable
    limit = 6
    limit = (stickies.count > limit) ? 1 : limit - stickies.count

    # Get the latest published, frontable, not sticky and with no password posts by go_live
    posts = posts.order('go_live DESC').where( :state => :published, :is_frontable => true, :is_sticky => false, :password => nil )
    # Make sure we are talking about posts or messages
    posts = posts.where( t[:kind].matches(:post).or(t[:kind].matches(:message)))
    # If a query is set, use it to filter the output
    posts = posts.where(["content like ?", '%'+@query+'%'] ) if @query.present?
    # Limit the number of posts to show
    posts = posts.limit(limit)
    # Set the offset if we aren't on the first page.
    posts = posts.offset(limit.to_i * page.to_i) if page > 0

    # Get our filtered post count for pagination
    filtered_post_count = stickies.count + posts.count
    # Need this to show a previous/next button
    @pagination_number_of_pages = (filtered_post_count / limit)
    @pagination_current_page = (page.to_i + 1) > 0 ? (page.to_i + 1) : 1

    # Return our posts
    stickies + posts
  end

end
