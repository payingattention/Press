class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :display_name, :gender, :is_admin

  # Ultra simple "not null" validators
  validates_presence_of :first_name, :last_name, :display_name, :gender, :email

  # To configure a different table name
  # set_table_name("some_other_table") OR change the class name and file name

  has_many :posts

  scope :administrator, where(:admin => true)

end
