class InstallController < ApplicationController

  skip_before_filter :installed?

  layout 'install'

  def index
  end

end


