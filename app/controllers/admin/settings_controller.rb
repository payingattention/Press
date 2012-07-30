class Admin::SettingsController < ApplicationController

  before_filter :authenticate_user!

  layout 'admin'

  def index
    @settings = list_models Setting
  end

end
