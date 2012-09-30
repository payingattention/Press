class Admin::PagesController < AdminController

  # NEW
  def new
    # Map all users out to a name, id pair for the select box
    @all_users = User.all.map { |a| [a.display_name, a.id] }
    # Instance our post object to set form defaults
    @page = Post.new :object_type => :page, :go_live => DateTime.now

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @page }
    end
  end

  # CREATE
  def create
    # Instance new object
    @page = Post.new params[:post]
    @page.user_id = current_user
    # Save object
    respond_to do |format|
      if @page.save
        flash[:success] = 'Post Created.'
        format.html { redirect_to admin_content_index_path(:pages), notice: 'Post was successfully created.' }
        format.json { render json: @page, status: :created, location: @page }
      else
        format.html { render action: "new" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # EDIT
  def edit
    # Map all users out to a name, id pair for the select box
    @all_users = User.all.map { |a| [a.display_name, a.id] }
    # Instance the post
    @page = Post.find_by_id params[:id]
    unless @page
      redirect_to admin_content_index :pages
    end
  end

  # UPDATE
  def update
    @page = Post.find_by_id params[:id]
    unless @page
      redirect_to admin_content_index_path :pages
    end

    respond_to do |format|
      if @page.update_attributes(params[:post])
        flash[:success] = 'Post Edited.'
        format.html { redirect_to admin_content_index_path(:pages), notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DESTROY
  def destroy
    @page = Post.find_by_id params[:id]
    unless @page
      redirect_to :action => 'index'
    end

    @page.destroy
    respond_to do |format|
      format.html { redirect_to admin_content_index_path :pages }
      format.json { head :no_content }
    end
  end

end
