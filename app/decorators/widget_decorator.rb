class WidgetDecorator < Draper::Base
  decorates :widget

  def render_admin_button
    h.content_tag :div, :class => 'well well-small widget-admin-button' + (is_droppable ? ' droppable' : '') do
      title
    end
  end

end
