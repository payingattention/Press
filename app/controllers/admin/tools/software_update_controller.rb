class Admin::Tools::SoftwareUpdateController < ApplicationController

  skip_before_filter :installed?

  layout 'admin'

  def index
    @localVersionHash = %x{git rev-parse HEAD}.chomp
    @remoteVersionHash = %x{git rev-parse origin/master}.chomp
    @localVersion = %x{cat VERSION}
    @remoteVersion = %x{curl https://raw.github.com/palamedes/Press/master/VERSION}
  end

end


