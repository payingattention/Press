class Admin::Tools::SoftwareUpdateController < ApplicationController

  skip_before_filter :installed?

  layout 'admin'

  def index
  end

end


