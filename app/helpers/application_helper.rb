module ApplicationHelper

  # breadcrumbs!
  def render_breadcrumbs options = { }
    options[:filter]          ||= nil
    options[:home]            ||= { :name => 'Home', :link => { :action => 'index', :query => options[:filter] } }
    options[:post]            ||= nil
    options[:category]        ||= options[:post].categories.first if options[:post].present?
    options[:tag]             ||= nil
    options[:span_size]       ||= 'span9'
    options[:container]       ||= false
    options[:divider]         ||= '/'
    options[:filter_divider]  ||= '::'

    breadcrumbs = []
    breadcrumbs << link_to( options[:home][:name], options[:home][:link] )
    breadcrumbs << link_to( options[:category].name.capitalize, '/category/' + options[:category].seo_url + url_query ) if options[:category].present?
    breadcrumbs << link_to( options[:tag].name.capitalize, '/tag/' + options[:tag].seo_url + url_query ) if options[:tag].present?
    breadcrumbs << link_to( options[:post].title, '/' + options[:post].seo_url + url_query ) if options[:post].present?

    render :partial => 'shared/breadcrumbs',
       :locals => {
           :breadcrumbs       => breadcrumbs,
           :filter            => options[:filter],
           :divider           => options[:divider],
           :filter_divider    => options[:filter_divider],
           :span_size         => options[:span_size],
           :render_container  => options[:container]
       }
  end

  # Append to the URL the query string if it exists
  def url_query
    (@query.present?)?'?query='+@query:''
  end

  # Render markdown to html
  def render_markdown content, options = { }
    options[:xhtml]                  ||= true
    options[:query]                  ||= nil
    options[:autolink]               ||= true
    options[:space_after_headers]    ||= true
    options[:no_intra_emphasis]      ||= true

    renderer = options[:xhtml] ? Redcarpet::Render::XHTML : Redcarpet::Render::HTML

    content.gsub!(/(#{options[:query]})/i, '<span class="highlight">\1</span>') if options[:query].present?

    md = Redcarpet::Markdown.new renderer, options
    md.render(content).html_safe
  end

  # Pagination!
  def pagination options = { }
    options[:number_of_pages]   ||= @pagination_number_of_pages
    options[:current_page]      ||= @pagination_current_page
    options[:filter]            ||= @filter
    options[:pre_post_size]     ||= 5
    options[:show_first]        ||= 2
    options[:show_last]         ||= 2
    options[:show_next]         ||= true
    options[:show_previous]     ||= true
    options[:show_all]          ||= false

    prev_page = nil
    first_pages = nil
    primary_pages = []
    last_pages = nil
    next_page = nil

    if options[:show_all]
      primary_pages = 0..(options[:number_of_pages]-1)
    else

      if options[:show_previous] && (options[:current_page]-1) > 0
        prev_page = options[:current_page] - 1
      end

      first_pages = 0..(options[:show_first]-1)
      if options[:current_page] < options[:show_first] + options[:pre_post_size]
        first_pages = nil
      end

      options[:number_of_pages].times { |p|
        primary_pages << p if p.to_i >= (options[:current_page].to_i - options[:pre_post_size].to_i - 1) && p.to_i < (options[:current_page].to_i + options[:pre_post_size].to_i)
      }

      last_pages = (options[:number_of_pages]-options[:show_last])..options[:number_of_pages]-1
      if options[:current_page] > options[:number_of_pages] - options[:show_last] - options[:pre_post_size] + 1
        last_pages = nil
      end

      if options[:show_next] && (options[:current_page]) < options[:number_of_pages]
        next_page = options[:current_page] + 1
      end

    end

    render :partial => 'shared/pagination',
           :locals => {
               :first_pages       => first_pages,
               :last_pages        => last_pages,
               :primary_pages     => primary_pages,
               :next_page         => next_page,
               :prev_page         => prev_page,
               :current_page      => options[:current_page],
               :filter            => options[:filter]
           }
  end


end
