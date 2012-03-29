class Admin::TagsController < ApplicationController

  before_filter :authenticate_user!

  layout 'admin'

  # GET /admin/tags
  # GET /admin/tags.json
  def index
    limit = 10;
    page = (params[:page].to_i - 1) || 1
    @filter = params[:filter] || ''

    @tags = Tag.order('created_at DESC')
    @total_count = @tags.count
    @tags = @tags.where(["name like ? or description like ?", '%'+@filter+'%', '%'+@filter+'%'] ) if @filter.present?
    @filtered_count = @tags.count
    @tags = @tags.limit(limit)
    @tags = @tags.offset(limit.to_i * page.to_i) if page > 0

    @pagination_current_page = (page.to_i + 1) > 0 ? (page.to_i + 1) : 1
    @pagination_number_of_pages = (@filtered_count / limit) +1

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tags }
    end
  end

  # GET /admin/tags/1
  # GET /admin/tags/1.json
  def show
    @tag = Tag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tag }
    end
  end

  # GET /admin/tags/new
  # GET /admin/tags/new.json
  def new
    @tag = Tag.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tag }
    end
  end

  # GET /admin/tags/1/edit
  def edit
    @tag = Tag.find(params[:id])
  end

  # POST /admin/tags
  # POST /admin/tags.json
  def create
    @tag = Tag.new(params[:tag])

    respond_to do |format|
      if @tag.save
        format.html { redirect_to admin_tags_path, notice: 'Tag was successfully created.' }
        format.json { render json: @tag, status: :created, location: @tag }
      else
        format.html { render action: "new" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/tags/1
  # PUT /admin/tags/1.json
  def update
    @tag = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        format.html { redirect_to admin_tags_path, notice: 'Tag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/tags/1
  # DELETE /admin/tags/1.json
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to admin_tags_url }
      format.json { head :no_content }
    end
  end
end
