module ApplicationHelper

  # breadcrumbs!
  def render_breadcrumbs options = { }
    options[:home]            ||= { :name => 'Home', :link => { :action => 'index'} }
    options[:post]            ||= nil
    options[:category]        ||= options[:post].categories.first if options[:post].present?
    options[:tag]             ||= nil
    options[:filter]          ||= nil
    options[:span_size]       ||= 'span9'
    options[:container]       ||= false
    options[:divider]         ||= '/'
    options[:filter_divider]  ||= '::'

    breadcrumbs = []
    breadcrumbs << link_to( options[:home][:name], options[:home][:link] )
    breadcrumbs << link_to( options[:category].name.capitalize, '/category/' + options[:category].seo_url ) if options[:category].present?
    breadcrumbs << link_to( options[:tag].name.capitalize, '/tag/' + options[:tag].seo_url ) if options[:tag].present?
    breadcrumbs << link_to( options[:post].title, '/' + options[:post].seo_url ) if options[:post].present?

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

end
