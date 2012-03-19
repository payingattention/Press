class DefaultController < ApplicationController

  layout 'application'
  #
  def index
    # Get the 5 latest
    limit = 5;
    page = (params[:page].to_i - 1) || 1
    @filter = params[:filter] || ''

    @posts = Post.order('go_live DESC')
    @total_post_count = @posts.count
    @posts = @posts.where(["title like ?", '%'+@filter+'%'] ) if @filter
    @filtered_post_count = @posts.count
    @posts = @posts.limit(limit)
    @posts = @posts.offset(limit.to_i * page.to_i) if page > 0

    @pagination_current_page = (page.to_i + 1) > 0 ? (page.to_i + 1) : 1
    @pagination_number_of_pages = (@filtered_post_count / limit) +1

  end

end
