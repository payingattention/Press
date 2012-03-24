class Admin::UsersController < ApplicationController

  before_filter :authenticate_user!

  layout 'admin'

  # LIST
  def index
    @users = User.order('created_at ASC')
  end

  # NEW
  def new
    @user = User.new
  end

  # CREATE
  def create
    @user = User.new params[:user]
#    @user.salt = Digest::MD5.hexdigest(Time.now.utc.to_s)
#    @user.password = Digest::MD5.hexdigest(@user.salt + @user.password)

    if @user.save
      flash[:success] = 'User Created.'
      redirect_to :action => 'index'
    else
      render 'new'
    end
  end

  # EDIT
  def edit
    @user = User.find_by_id params[:id]
    unless @user
      redirect_to :action => 'index'
    end
  end

  # UPDATE
  def update
    @user = User.find_by_id params[:id]
    unless @user
      redirect_to :action => 'index'
    end

    if params[:user][:password] == ''
      params[:user][:password] = @user.password
    else
      params[:user][:password] = Digest::MD5.hexdigest(@user.salt + params[:user][:password])
    end

    if @user.update_attributes params[:user]
      flash[:success] = 'User Edited.'
      redirect_to :action => 'index'
    else
      render 'edit'
    end
  end

  # DESTROY
  def destroy
    @user = User.find_by_id params[:id]
    unless @user
      redirect_to :action => 'index'
    end

    if @user.destroy
      flash[:success] = 'User Deleted.'
      redirect_to :action => 'index'
    else
      flash[:error] = 'User failed to delete.'
      redirect_to :action => 'index'
    end
  end



end
