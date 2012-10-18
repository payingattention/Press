module ModelHelper

  # Wash all the crap out of the SEO url
  def self.strip_seo_url seo
    seo.downcase.gsub(/\s/,'-').gsub(/[^0-9a-z\-\_]/,'')
  end

  # Create a hard backup of this file on the file system (outside of the database)
  # that can be indexed and saved using github or some such repository
  def self.backup directoryName, fileName, model
    if Setting.getValue('backup') && Setting.getValue('backup_location').present?

      # @TODO -- check to see if the dir exists, if it doesn't add it.

      File.open("#{Setting.getValue('backup_location')}/#{directoryName}/#{fileName}.json", 'w+') do |fh|
        fh.write model.to_json
      end

      # @TODO -- check to see if we have git defined in settings.. if we do, add, commit and push

    end
  end

end