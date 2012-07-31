class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :display_name, :gender, :url

  # Ultra simple "not null" validators
  validates_presence_of :display_name, :gender, :email

  # Users have many posts
  # user.posts references all the posts that users has made
  has_many :posts

  scope :owner, where(:role => :owner)
  scope :admin, where(:role => :admin)
  scope :moderator, where(:role => :moderator)
  scope :user, where(:role => :user)
  scope :guest, where(:role => :guest)


  def add_guest
    # Displayname, IP, User ID if user, Email, URL
  end

  def fullname
    first_name + ' ' + last_name
  end

  def name
    display_name
  end

end
