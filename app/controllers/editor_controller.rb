class EditorController < ApplicationController
  def index
    # Show a list
    # Click to edit, then edit one
    # Click new to create, then create one
    puts params
    post = params :post

    puts post
  end

  # Create new post method
  def create
    # Map all users out to a name, id pair for the select box
    @all_users = User.all.map { |a| [a.display_name, a.id] }
    # Instance our post object to set form defaults
    @post = Post.new
  end
end
