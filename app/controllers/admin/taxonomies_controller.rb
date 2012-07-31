class Admin::TaxonomiesController < AdminController

  # GET /admin/taxonomies
  # GET /admin/taxonomies.json
  def index
    limit = 10;
    page = (params[:page].to_i - 1) || 1
    @filter = params[:filter] || ''

    @taxonomies = Taxonomy.order('created_at DESC')
    @total_count = @taxonomies.count
    @taxonomies = @taxonomies.where(["name like ? or description like ?", '%'+@filter+'%', '%'+@filter+'%'] ) if @filter.present?
    @filtered_count = @taxonomies.count
    @taxonomies = @taxonomies.limit(limit)
    @taxonomies = @taxonomies.offset(limit.to_i * page.to_i) if page > 0

    @pagination_current_page = (page.to_i + 1) > 0 ? (page.to_i + 1) : 1
    @pagination_number_of_pages = (@filtered_count / limit) +1

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @taxonomies }
    end
  end

  # GET /admin/taxonomies/1
  # GET /admin/taxonomies/1.json
  def show
    @taxonomy = Taxonomy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @taxonomy }
    end
  end

  # GET /admin/taxonomies/new
  # GET /admin/taxonomies/new.json
  def new
    @taxonomy = Taxonomy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @taxonomy }
    end
  end

  # GET /admin/taxonomies/1/edit
  def edit
    @taxonomy = Taxonomy.find(params[:id])
  end

  # POST /admin/taxonomies
  # POST /admin/taxonomies.json
  def create
    @taxonomy = Taxonomy.new(params[:taxonomy])

    respond_to do |format|
      if @taxonomy.save
        format.html { redirect_to admin_taxonomies_path, notice: 'Taxonomy was successfully created.' }
        format.json { render json: @taxonomy, status: :created, location: @taxonomy }
      else
        format.html { render action: "new" }
        format.json { render json: @taxonomy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/taxonomies/1
  # PUT /admin/taxonomies/1.json
  def update
    @taxonomy = Taxonomy.find(params[:id])

    respond_to do |format|
      if @taxonomy.update_attributes(params[:taxonomy])
        format.html { redirect_to admin_taxonomies_path, notice: 'Taxonomy was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @taxonomy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/taxonomies/1
  # DELETE /admin/taxonomies/1.json
  def destroy
    @taxonomy = Taxonomy.find(params[:id])
    @taxonomy.destroy

    respond_to do |format|
      format.html { redirect_to admin_taxonomies_url }
      format.json { head :no_content }
    end
  end
end
