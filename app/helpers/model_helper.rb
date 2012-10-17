module ModelHelper

  # Wash all the crap out of the SEO url
  def self.strip_seo_url seo
    seo.downcase.gsub(/\s/,'-').gsub(/[^0-9a-z\-\_]/,'')
  end

end