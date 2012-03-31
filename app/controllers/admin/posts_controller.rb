class Admin::PostsController < ApplicationController

  before_filter :authenticate_user!

  layout 'admin'

  # LIST -- Shows a list of posts
  def index
    # Set our limit, this should be dynamic or something.. drop box?
    limit = 12;

    # if we are talking about a tag, get our posts from there
    @tag = params[:tag] || ''
    if @tag.present?
      tag = Taxonomy.find_by_seo_url @tag
      @posts = tag.posts
    end

    # If we are talking about a category get the posts from there
    @category = params[:category] || ''
    if @category.present?
      category = Taxonomy.find_by_seo_url @category
      @posts = category.posts
    end

    # Define posts unless it already is
    @posts = Post.order unless @posts.present?
    # Set the default sort order
    @posts = @posts.order('go_live DESC')
    # Get our filter information if it's set
    @filter = params[:filter] || ''
    # Filter posts by title if the filter is set
    @posts = @posts.where(["title like ?", '%'+@filter+'%'] ) if @filter.present?
    # Get our filtered post count for pagination
    filtered_post_count = @posts.count
    # Limit the number to display
    @posts = @posts.limit(limit)
    # Define our page
    page = (params[:page].to_i - 1) || 1
    # Set page offset
    @posts = @posts.offset(limit.to_i * page.to_i) if page > 0
    # Output pagination information
    @pagination_current_page = (page.to_i + 1) > 0 ? (page.to_i + 1) : 1
    @pagination_number_of_pages = (filtered_post_count / limit) +1

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # NEW -- New post form method
  def new
    # Map all users out to a name, id pair for the select box
    @all_users = User.all.map { |a| [a.display_name, a.id] }
    # Instance our post object to set form defaults
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # CREATE -- Does the work of saving new post or back to new
  def create
    # Instance new object
    @post = Post.new params[:post]
    # Save object
    respond_to do |format|
      if @post.save
        flash[:success] = 'Post Created.'
        format.html { redirect_to [:admin, @post], notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # EDIT
  def edit
    # Map all users out to a name, id pair for the select box
    @all_users = User.all.map { |a| [a.display_name, a.id] }
    # Instance the post
    @post = Post.find_by_id params[:id]
    unless @post
      redirect_to :action => 'index'
    end
  end

  # UPDATE
  def update
    @post = Post.find_by_id params[:id]
    unless @post
      redirect_to :action => 'index'
    end

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:success] = 'Post Edited.'
        format.html { redirect_to admin_posts_url, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DESTROY
  def destroy
    @post = Post.find_by_id params[:id]
    unless @post
      redirect_to :action => 'index'
    end

    @post.destroy
    respond_to do |format|
      format.html { redirect_to admin_posts_url }
      format.json { head :no_content }
    end
  end

end
