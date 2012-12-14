class UserDecorator < Draper::Base
  decorates :user

  # Render the user panel
  def panel
    h.render :partial => 'default/user_panel', :locals => { :user => self }
  end

  # Logout Link
  def logout_link
    h.content_tag :li do
      h.link_to h.destroy_user_session_path, :"data-method" => :delete do
        h.content_tag(:i, '', :class => 'icon-exclamation-sign') + " Logout"
      end
    end
  end

  # Administration Link for admin only
  def admin_link
    if model.role == :admin || model.role == :owner
      h.content_tag :li do
        h.link_to h.admin_index_path do
          h.content_tag(:i, '', :class => 'icon-wrench') + " Site Administration"
        end
      end
    end
  end

end
