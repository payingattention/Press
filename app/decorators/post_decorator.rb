class PostDecorator < Draper::Base
  decorates :post

  # Render the header based on the model header and replace () with the url for now
  def header query = nil
    model.header.gsub '()', "(%s)" % h.url_for("/#{model.seo_url}/#{query}")
  end

  def render opts = { :tease => false }
    unless opts[:tease]
      h.render :partial => "content/#{kind}_show", :locals => { :"#{kind}" => self }
    else
      h.render :partial => "content/#{kind}_tease", :locals => { :"#{kind}" => self }
    end
  end

  def read_more_link
    if body.present?
      h.content_tag :div, :class => 'readmore' do
        h.link_to 'Read more...', full_url
      end
    end
  end

  def full_url query = nil
    "/#{seo_url}/#{query}"
  end

  def edit_link
    if h.current_user == user
      nav_item do
        h.link_to '<i class="icon-pencil"></i>Edit'.html_safe, h.edit_admin_content_path(kind, self)
      end
    end
  end

  def comments_link
    if allow_comments
      nav_item do
        h.link_to "<i class='icon-comment'></i>Comments (#{comments.count})".html_safe, "#{full_url}#comments"
      end
    end
  end

  def nav_item
    h.content_tag :li, :class => 'pull-right' do
      yield
    end
  end

  def nav_bar
    h.content_tag :div, :class => 'navbar' do
      h.content_tag :div, :class => 'navbar-inner' do
        h.content_tag :ul, :class => 'nav' do
          yield
        end
      end
    end
  end

  def content_panel
    # Class == content-panel and alert if is_closable etc
    h.content_tag :div, :class => 'content-panel' do
      yield
    end
  end

  def render_taxonomies type
    tax_list = send(type)
    tax_list.each do |tax|
      render_taxonomy tax
    end
  end

  def render_taxonomy tax
    h.render :partial => 'content/taxonomy', :locals => { :t => tax }
  end

  def render_comments
    comments.each do |comment|
      h.render :partials => 'posts/comment', :locals => { :comment => comment }
    end
  end

end