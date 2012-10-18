module ModelHelper

  # Wash all the crap out of the SEO url
  def self.strip_seo_url seo
    seo.downcase.gsub(/\s/,'-').gsub(/[^0-9a-z\-\_]/,'')
  end

  # Create a hard backup of this file on the file system (outside of the database)
  # that can be indexed and saved using github or some such repository
  def self.backup model
    if Setting.getValue('backup') && Setting.getValue('backup_location').present?
      filePath = "#{Setting.getValue('backup_location')}/#{model.class.to_s.downcase}/#{model.seo_url}.json"
      originalFilePath = "#{Setting.getValue('backup_location')}/#{model.class.to_s.downcase}/#{model.original_seo_url}.json"

      # If this file has been renamed, then rename it.
      if model.seo_url != model.original_seo_url && File.exists?(originalFilePath)
        File.rename(originalFilePath, filePath)
      end

      # @TODO -- check to see if the dir exists, if it doesn't add it.
      File.open(filePath, 'w+') do |fh|
        fh.write model.to_json
      end
      # @TODO -- check to see if we have git defined in settings.. if we do, add, commit and push
    end
  end

  # Destroy the hard backup of this file if it exists
  def self.destroy_backup model
    filePath = "#{Setting.getValue('backup_location')}/#{model.class.to_s.downcase}/#{model.seo_url}.json"

    if File.exists? filePath
      File.delete filePath
    end
    # @TODO - check to see if git defined, if it is git rm, commit and push
  end

end