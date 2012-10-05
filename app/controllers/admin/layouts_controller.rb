class Admin::LayoutsController < AdminController

  # LIST -- Shows a list of the content type [posts,pages,comments,messages,ads,etc...]
  def index

    @layouts = LayoutDecorator.decorate(list_models Layout.order, [], 'created_at desc')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @layouts }
    end
  end

end