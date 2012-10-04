class AdminController < ApplicationController

  skip_before_filter :installed?

  before_filter :userDecoratorToView
  before_filter :authenticate_user!

  layout 'admin'

  def index
  end

end
