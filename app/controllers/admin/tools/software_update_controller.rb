
class Admin::Tools::SoftwareUpdateController < ApplicationController

  skip_before_filter :installed?

  layout 'admin'

  def index

    @localVersionHash = %x{git rev-parse HEAD}.chomp
    @remoteVersionHash = %x{git rev-parse origin/master}.chomp
    @localVersion = %x{cat VERSION}
    @remoteVersion = "[Not sure the correct way to get this]"
    @updateLog = %x{git log #{@localVersionHash}..HEAD --oneline}

    @versionInformation = Curl::Easy.perform('https://raw.github.com/palamedes/Press/master/VERSION').body_str


  end

end


