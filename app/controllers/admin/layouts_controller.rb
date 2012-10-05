class Admin::LayoutsController < AdminController

  # LIST -- Shows a list of the layouts
  def index

    @layouts = LayoutDecorator.decorate(list_models Layout.order, [], 'created_at desc')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @layouts }
    end
  end

  # EDIT
  def edit
    # Instance the content
    @layout = Layout.find_by_id params[:id]

    unless @layout
      redirect_to admin_layouts_path
    end
  end


end