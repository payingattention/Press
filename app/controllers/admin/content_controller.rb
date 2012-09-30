class Admin::ContentController < AdminController

  # LIST -- Shows a list of the content type [posts,pages,comments,messages,ads,etc...]
  def index
    # Set our limit, this should be dynamic or something.. drop box?
    limit = 12;

    # if we are talking about a tag, get our posts from there
    #@tag = params[:tag] || ''
    #if @tag.present?
    #  tag = Taxonomy.find_by_seo_url @tag
    #  @posts = list_models tag.posts, [], 'go_live desc' if params[:type] == 'posts'
    #end

    # If we are talking about a category get the posts from there
    #@category = params[:category] || ''
    #if @category.present?
    #  category = Taxonomy.find_by_seo_url @category
    #  @posts = list_models category.posts, [], 'go_live desc' if params[:type] == 'posts'
    #end

    #if !@tag.present? && !@category.present?

    @content = list_models Post.posts, [], 'go_live desc' if params[:type] == 'posts'
    @content = list_models Post.pages, [], 'go_live desc' if params[:type] == 'pages'

    #end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

end
