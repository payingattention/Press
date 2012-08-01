class Admin::Tools::SoftwareUpdateController < AdminController

  def index
    localVersionHash = %x{git rev-parse HEAD}.chomp
    @updateLog = %x{git log #{localVersionHash}..HEAD --oneline}

    @localVersion = %x{cat VERSION}
    @remoteVersion = Curl::Easy.perform('https://raw.github.com/palamedes/Press/master/VERSION').body_str

  end

end


