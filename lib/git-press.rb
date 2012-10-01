require 'fileutils'
require 'time'

require 'digest/sha1'

module GitPress
  VERSION = '1.0.0'

  def self.version
    VERSION
  end

  def self.get_local_version_hash
    %x{git rev-parse HEAD}.chomp
  end

  def self.pull
    %x{git pull}
  end

end