class EditorController < ApplicationController

  layout 'admin'

  # LIST -- Shows a list of posts
  def index
    @posts = Post.order('created_at DESC')
  end

  # NEW -- New post form method
  def new
    # Map all users out to a name, id pair for the select box
    @all_users = User.all.map { |a| [a.display_name, a.id] }
    # Instance our post object to set form defaults
    @post = Post.new
  end

  # CREATE -- Does the work of saving new post or back to new
  def create
    # Instance new object
    @post = Post.new params[:post]
    # Save object
    if @post.save
      flash[:success] = 'Post Created.'
      redirect_to :action => 'index'
    else
      render 'new'
    end
  end

  # EDIT
  def edit
    # Map all users out to a name, id pair for the select box
    @all_users = User.all.map { |a| [a.display_name, a.id] }
    # Instance the post
    @post = Post.find_by_id params[:id]
    unless @post
      redirect_to :action => 'index'
    end
  end
  
  # UPDATE
  def update
    @post = Post.find_by_id params[:id]
    unless @post
      redirect_to :action => 'index'
    end

    # Update object
    if @post.update_attributes params[:post]
      flash[:success] = 'Post Edited.'
      redirect_to :action => 'index'
    else
      render 'edit'
    end
  end

  # DESTROY
  def destroy
    @post = Post.find_by_id params[:id]
    unless @post
      redirect_to :action => 'index'
    end

    if @post.destroy
      flash[:success] = 'Post Deleted.'
      redirect_to :action => 'index'
    else
      flash[:error] = 'Post failed to delete.'
      redirect_to :action => 'index'
    end
  end

end
