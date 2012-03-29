class Admin::PostsController < ApplicationController

  before_filter :authenticate_user!

  layout 'admin'

  # LIST -- Shows a list of posts
  def index
    limit = 10;
    page = (params[:page].to_i - 1) || 1
    @filter = params[:filter] || ''

    @posts = Post.order('go_live DESC')
    @total_post_count = @posts.count
    @posts = @posts.where(["title like ?", '%'+@filter+'%'] ) if @filter
    @filtered_post_count = @posts.count
    @posts = @posts.limit(limit)
    @posts = @posts.offset(limit.to_i * page.to_i) if page > 0

    @pagination_current_page = (page.to_i + 1) > 0 ? (page.to_i + 1) : 1
    @pagination_number_of_pages = (@filtered_post_count / limit) +1

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
