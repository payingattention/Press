class Setting < ActiveRecord::Base

  # Setup accessible (or protected) attributes for your model
  attr_accessible :value

  # Ultra simple "not null" validators
  # validates_presence_of :value

  # Are we currently installing? (Meaning is it not installed yet)
  scope :installing?, where(:key => :maintenance,:value => "-1")

end