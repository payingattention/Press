class Admin::PostsController < AdminController

  # LIST -- Shows a list of posts
  def index
    # Set our limit, this should be dynamic or something.. drop box?
    limit = 12;

    # if we are talking about a tag, get our posts from there
    @tag = params[:tag] || ''
    if @tag.present?
      tag = Taxonomy.find_by_seo_url @tag
      @posts = list_models tag.posts, [], 'go_live desc'
    end

    # If we are talking about a category get the posts from there
    @category = params[:category] || ''
    if @category.present?
      category = Taxonomy.find_by_seo_url @category
      @posts = list_models category.posts, [], 'go_live desc'
    end

    if !@tag.present? && !@category.present?
      @posts = list_models Post.posts, [], 'go_live desc'
    end

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
