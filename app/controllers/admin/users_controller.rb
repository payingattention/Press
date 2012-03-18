class Admin::UsersController < ApplicationController

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
    @user.salt ||= '123456' # @TODO Temporary user salt
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
