class Medium < ActiveRecord::Base

  # Mass assignable fields
  attr_accessible :file
  # Uploader
  mount_uploader :file, FileUploader

  belongs_to :content

end
