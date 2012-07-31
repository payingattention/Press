class Admin::SettingsController < AdminController

  def index
    @settings = list_models Setting
  end

end
