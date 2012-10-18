class Admin::ContentController < AdminController

  # LIST -- Shows a list of the content type [posts,pages,comments,messages,ads,etc...]
  def index
    # Set our limit, this should be dynamic or something.. drop box?
    limit = 12

    # if we are talking about a tag, get our posts from there
    #@tag = params[:tag] || ''
    #if @tag.present?
    #  tag = Taxonomy.find_by_seo_url @tag
    #  @posts = list_models tag.posts, [], 'go_live desc' if params[:type] == 'posts'
    #end

    # If we are talking about a category get the posts from there
    #@category = params[:category] || ''
    #if @category.present?
    #  category = Taxonomy.find_by_seo_url @category
    #  @posts = list_models category.posts, [], 'go_live desc' if params[:type] == 'posts'
    #end

    #if !@tag.present? && !@category.present?


    @contents = ContentDecorator.decorate(list_models Content, [], 'go_live desc')

    #end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contents }
    end
  end

  # NEW
  def new
    # Instance our content object to set form defaults
    @content = Content.new :go_live => DateTime.now

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @content }
    end
  end

  # CREATE
  def create
    # Instance new object
    @content = Content.new params[:content]
    @content.user_id = current_user
    # Save object
    respond_to do |format|
      if @content.save
        format.html { redirect_to admin_content_index_path, notice: 'Content was successfully created.' }
        format.json { render json: @content, status: :created, location: @content }
      else
        format.html { render action: "new" }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # EDIT
  def edit
    # Instance the content
    @content = Content.find_by_id params[:id]

    unless @content
      redirect_to admin_content_index_path
    end
  end

  # UPDATE
  def update
    @content = Content.find_by_id params[:id]
    unless @content
      redirect_to admin_content_index_path
    end

    respond_to do |format|
      if @content.update_attributes(params[:content])

        @content.taxonomies.clear
        params[:taxonomies].each do |tax|
          taxonomy = Taxonomy.find_by_id tax
          @content.taxonomies << taxonomy if taxonomy.present?
        end if params[:taxonomies].present?

        format.html { redirect_to admin_content_index_path, notice: 'Content was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DESTROY
  def destroy
    @content = Content.find_by_id params[:id]
    unless @content
      redirect_to admin_content_index_path
    end

    @content.destroy
    respond_to do |format|
      format.html { redirect_to admin_content_index_path }
      format.json { head :no_content }
    end
  end

  # Get the categories list form helper for this piece of content
  def categories
    # Instance the content
    @content = Content.find_by_id params[:id]

    respond_to do |format|
      format.html { render :template => 'admin/taxonomies/_categories_form.html.erb', :layout => nil }
    end
  end

end
