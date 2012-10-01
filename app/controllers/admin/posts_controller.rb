class Admin::PostsController < AdminController

  # NEW
  def new
    # Map all users out to a name, id pair for the select box
    @all_users = User.all.map { |a| [a.display_name, a.id] }
    # Instance our post object to set form defaults
    @post = Post.new :object_type => :post, :go_live => DateTime.now
    # Send along all categories for us to choose from
    @categories = Taxonomy.categories

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # CREATE
  def create
    # Instance new object
    @post = Post.new params[:post]
    @post.user_id = current_user
    # Save object
    respond_to do |format|
      if @post.save
        flash[:success] = 'Post Created.'
        format.html { redirect_to admin_content_index_path(:posts), notice: 'Post was successfully created.' }
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
    # Send along all categories for us to choose from
    @categories = Taxonomy.categories

    unless @post
      redirect_to admin_content_index :posts
    end
  end

  # UPDATE
  def update
    @post = Post.find_by_id params[:id]
    unless @post
      redirect_to admin_content_index_path :posts
    end

    respond_to do |format|
      if @post.update_attributes(params[:post])

        @post.taxonomies.clear
        params[:taxonomies].each do |tax|
          taxonomy = Taxonomy.find_by_id tax
          @post.taxonomies << taxonomy if taxonomy.present?
        end if params[:taxonomies].present?

        format.html { redirect_to admin_content_index_path(:posts), notice: 'Post was successfully updated.' }
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
      format.html { redirect_to admin_content_index_path :posts }
      format.json { head :no_content }
    end
  end

end
