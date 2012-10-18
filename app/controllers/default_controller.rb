class DefaultController < ApplicationController

  layout 'application'

  # Show the front page!
  def index
    # Catch old legacy wordpress routing ?p=####
    content = Content.find_by_id params[:p]
    if content.present?
      redirect_to :action => 'show', :seo_url => content.seo_url
    else
      # Okay get me ma'content
      @contents = ContentDecorator.decorate(get_contents Content.order)

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @contents }
      end
    end

  end

  # Show a post or page, based on the SEO Url
  def show
    #load the post or page by seo url or return to index if not found
    @content = ContentDecorator.find_by_seo_url params[:seo_url]
    if @content.present?
      @query = params[:query] || ''

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @content }
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
      @contents = ContentDecorator.decorate(get_contents category.contents, { :state => :published, :is_indexable => true, :is_sticky => false, :password => nil })

      respond_to do |format|
        format.html { render :template => 'default/index' }
        format.json { render json: @contents }
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
      @contents = ContentDecorator.decorate(get_contentss tag.contents, { :state => :published, :is_indexable => true, :is_sticky => false, :password => nil })

      respond_to do |format|
        format.html { render :template => 'default/index' }
        format.json { render json: @contents }
      end
    else
      # No such category found, redirect to root index
      redirect_to root_path
    end
  end

  private

  # Paginate and process our requested contents.. Used by Index, Category and Tag
  def get_contents contents = Content.order, where = {:state => :published, :is_frontable => true, :is_sticky => false, :password => nil}
    # We'll need this
    t = Content.arel_table
    # Our page number
    page = (params[:page].to_i - 1) || 1
    # Our query if there is one set
    @query = params[:query] || ''

    stickies_where = { :state => :published, :is_sticky => true }
    stickies_where[:is_frontable] = true if where[:is_frontable]
    stickies_where[:is_indexable] = true if where[:is_indexable]
    # Get all the published, frontable sticky posts first
    stickies = Content.order('go_live DESC').where( stickies_where )

    # Get the 6 latest -- TODO this should be configurable
    limit = 6
    limit = (stickies.count > limit) ? 1 : limit - stickies.count

    # Get the latest published, frontable, not sticky and with no password posts by go_live
    contents = contents.order('go_live DESC').where( where )
    # If a query is set, use it to filter the output
    contents = contents.where(["text like ?", '%'+@query+'%'] ) if @query.present?
    # Limit the number of content to show
    contents = contents.limit(limit)
    # Set the offset if we aren't on the first page.
    contents = contents.offset(limit.to_i * page.to_i) if page > 0

    # Get our filtered content count for pagination
    filtered_content_count = stickies.count + contents.count
    # Need this to show a previous/next button
    @pagination_number_of_pages = (filtered_content_count > limit) ? (filtered_content_count / limit) + 1 : 1
    @pagination_current_page = (page.to_i + 1) > 0 ? (page.to_i + 1) : 1

    # Return our content
    stickies + contents
  end

end
