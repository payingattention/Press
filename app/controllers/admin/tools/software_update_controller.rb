
class Admin::Tools::SoftwareUpdateController < ApplicationController

  skip_before_filter :installed?

  layout 'admin'

  def index

    @localVersion = %x{cat VERSION}
    @remoteVersion = Curl::Easy.perform('https://raw.github.com/palamedes/Press/master/VERSION').body_str

  end

end


