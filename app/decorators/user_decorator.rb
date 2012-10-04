class UserDecorator < Draper::Base
  decorates :user

  # Render the user panel
  def panel
    h.render :partial => 'default/user_panel', :locals => { :user => model }
  end

end
