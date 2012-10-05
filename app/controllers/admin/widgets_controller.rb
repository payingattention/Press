class Admin::WidgetsController < AdminController

  # LIST -- Shows a list of the content type [posts,pages,comments,messages,ads,etc...]
  def index

    @widgets = WidgetDecorator.decorate(list_models Widget.order, [], 'created_at desc')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @widgets }
    end
  end

end