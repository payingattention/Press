class ContentDecorator < Draper::Base
  decorates :content

  # Render the header based on the model header and make any ### header a link to itself.
  def header query = nil
    model.header.gsub(/^\#\#\#\s(.*?)(\r|\n)/, '### [\1](%s)\2' % h.url_for("/#{model.seo_url}/#{query}"))
  end

  # Render the show or tease partial depending on whats being called
  def render options = { :tease => false }
    unless options[:tease]
      h.render :partial => "default/content_show", :locals => { :content => self }
    else
      h.render :partial => "default/content_tease", :locals => { :content => self }
    end
  end

  # Render the content panel based on the type of content this is
  def content_panel options = { :tease => false, :class => '' }
    options[:class] << style.to_s
    options[:class] << ' alert' if is_closable
    h.content_tag :div, :class => "content-panel #{options[:class]}" do
      yield
    end
  end

  # Our close button
  def close_button
    "<button class='close' data-dismiss='alert'>&times;</button>".html_safe if is_closable
  end

  # Render out the read more link if the body is present
  def read_more_link query = nil
    if body.present?
      h.content_tag :div, :class => 'readmore' do
        h.link_to 'Read more...', full_url(query)
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
        h.link_to '<i class="icon-pencil"></i>Edit'.html_safe, h.edit_admin_content_path(self)
      end
    end
  end

  # Give us a comment link, if we allow comments
  def comments_link
    if allow_comments
      nav_item do
        h.link_to "<i class='icon-comments'></i>Comments (#{comments.count})".html_safe, "#{full_url}#comments"
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
  def nav_bar options = { :class => '' }
    h.content_tag :div, :class => "navbar #{options[:class]}" do
      h.content_tag :div, :class => 'navbar-inner' do
        h.content_tag :ul, :class => 'nav' do
          yield
        end
      end
    end
  end

  # Render our the taxonomies based on the type
  def render_taxonomies type
    tax_list = send(type)
    render_list = tax_list.map_with_index do |tax, index|
      h.content_tag :li do
        if index == 0
          h.link_to "/#{tax.classification}/#{tax.seo_url}" do
            case type
              when :categories
                "<i class='icon-folder-open'></i> #{tax.name.capitalize}".html_safe
              when :tags
                "<i class='icon-tags'></i> #{tax.name.capitalize}".html_safe
              else
                tax.name.capitalize
            end
          end
        else
          h.link_to tax.name.capitalize, "/#{tax.classification}/#{tax.seo_url}"
        end
      end
    end.join.html_safe
  end

  # Posts have a little [Md] far right that you can click to get the actual mark down
  def render_markdown_link
    h.content_tag :li, :class => "pull-right" do
      h.link_to "/#{seo_url}.md/" do
        h.content_tag :small do
          "[M&dArr;]".html_safe
        end
      end
    end
  end

  # Render Comments
  def render_comments
    comments.map_with_index do |comment, index|
#      h.render :partials => 'default/comment', :locals => { :comment => comment }
    end.join.html_safe
  end

end