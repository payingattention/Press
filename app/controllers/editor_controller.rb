class EditorController < ApplicationController

  # LIST -- Shows a list of posts
  def index
    # Show a list
    @posts = Post.order('created_at ASC')
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
      # if success send back to index
      redirect_to :action => 'index'
    else
      # if fail send back to form and rerender the @post new form
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
    # Instance post object
    @post = Post.find_by_id params[:id]
    unless @post
      redirect_to :action => 'index'
    end

    # Update object
    if @post.update_attributes params[:post]
      # if success send back to index
      redirect_to :action => 'index'
    else
      # if fail send back to form and rerender the @post form
      render 'edit'
    end
  end

end
