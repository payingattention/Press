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

end
