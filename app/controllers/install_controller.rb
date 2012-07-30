class InstallController < ApplicationController

  skip_before_filter :installed?

  layout 'install'

  def index
    @user = User.first || User.new
    unless @user.new_record?
      redirect_to admin_settings_path
    end
  end

  def create_owner
    unless User.first.present?
      @user = User.new params[:user]
      @user.role = 'owner'
      if @user.save
        mode = Setting.find_by_key :maintenance
        mode.value = 0
        mode.save

        flash[:success] = 'Site Owner Successfully Created.'
        redirect_to :action => 'index'
      else
        render 'index'
      end
    end
  end

end


