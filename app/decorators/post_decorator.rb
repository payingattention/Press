class PostDecorator < Draper::Base
  decorates :post

  # Render the header based on the model header and replace () with the url for now
  def header query = nil
    model.header.gsub '()', "(%s)" % h.url_for("/#{model.seo_url}/#{query}")
  end

  # Render the show or tease partial depending on whats being called
  def render opts = { :tease => false }
    unless opts[:tease]
      h.render :partial => "content/#{kind}_show", :locals => { :"#{kind}" => self }
    else
      h.render :partial => "content/#{kind}_tease", :locals => { :"#{kind}" => self }
    end
  end

  # Render the content panel based on the type of content this is
  def content_panel opts = { :tease => false }
    # Class == content-panel and alert if is_closable etc
    h.content_tag :div, :class => 'content-panel' do
      yield
    end
  end

  # Render out the read more link if the body is present
  def read_more_link
    if body.present?
      h.content_tag :div, :class => 'readmore' do
        h.link_to 'Read more...', full_url
      end
    end
  end

  # Get our full url
  def full_url query = nil
    "/#{seo_url}/#{query}"
  end

  # Give us an edit link if we are the editor
  def edit_link
    if h.current_user == user
      nav_item do
        h.link_to '<i class="icon-pencil"></i>Edit'.html_safe, h.edit_admin_content_path(kind, self)
      end
    end
  end

  # Give us a comment link, if we allow comments
  def comments_link
    if allow_comments
      nav_item do
        h.link_to "<i class='icon-comment'></i>Comments (#{comments.count})".html_safe, "#{full_url}#comments"
      end
    end
  end

  # Nav item internal helper
  def nav_item
    h.content_tag :li, :class => 'pull-right' do
      yield
    end
  end

  # Nav bar!
  def nav_bar
    h.content_tag :div, :class => 'navbar' do
      h.content_tag :div, :class => 'navbar-inner' do
        h.content_tag :ul, :class => 'nav' do
          yield
        end
      end
    end
  end

  # Render our the taxonomies (THIS FAILS)
  def render_taxonomies type
    tax_list = send(type)
    tax_list.each do |tax|
      render_taxonomy tax
    end
  end

  # Render a specific taxonomy using the partial
  def render_taxonomy tax
    h.render :partial => 'content/taxonomy', :locals => { :t => tax }
  end

  # Render Comments
  def render_comments
    comments.each do |comment|
      h.render :partials => 'content/comment', :locals => { :comment => comment }
    end
  end

end