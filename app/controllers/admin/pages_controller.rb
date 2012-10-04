class Admin::PagesController < AdminController

  # NEW
  def new
    # Map all users out to a name, id pair for the select box
    @all_users = User.all.map { |a| [a.display_name, a.id] }
    # Instance our content object to set form defaults
    @content = Content.new :kind => :page, :go_live => DateTime.now

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
        format.html { redirect_to admin_content_index_path(:pages), notice: 'Page was successfully created.' }
        format.json { render json: @content, status: :created, location: @content }
      else
        format.html { render action: "new" }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # EDIT
  def edit
    # Map all users out to a name, id pair for the select box
    @all_users = User.all.map { |a| [a.display_name, a.id] }
    # Instance the content
    @content = Content.find_by_id params[:id]

    unless @content
      redirect_to admin_content_index :pages
    end
  end

  # UPDATE
  def update
    @content = Content.find_by_id params[:id]
    unless @content
      redirect_to admin_content_index_path :pages
    end

    respond_to do |format|
      if @content.update_attributes(params[:content])

        @content.taxonomies.clear
        params[:taxonomies].each do |tax|
          taxonomy = Taxonomy.find_by_id tax
          @content.taxonomies << taxonomy if taxonomy.present?
        end if params[:taxonomies].present?

        format.html { redirect_to admin_content_index_path(:pages), notice: 'Page was successfully updated.' }
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
      redirect_to :action => 'index'
    end

    @content.destroy
    respond_to do |format|
      format.html { redirect_to admin_content_index_path :pages }
      format.json { head :no_content }
    end
  end

end
