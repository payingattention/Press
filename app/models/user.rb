class User < ActiveRecord::Base

  # To configure a different table name
  # set_table_name("some_other_table") OR change the class name and file name

  validates_presence_of :email, :password, :salt

end
