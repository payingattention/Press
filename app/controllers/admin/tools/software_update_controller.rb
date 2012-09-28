require 'git-press'
class Admin::Tools::SoftwareUpdateController < AdminController

  def index
    @localVersion = %x{cat VERSION}
    @remoteVersion = Curl::Easy.perform('https://raw.github.com/palamedes/Press/master/VERSION').body_str
  end

  def upgrade
    GitPress.pull
  end

end


