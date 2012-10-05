
module BreadcrumbsHelper

  # breadcrumbs!
  def breadcrumbs options = { }
    options = { } if options.nil?
    namespace = controller.class.to_s.split("::").first.downcase + "_index_path"

    # Namespace filters
    case namespace
      when "admincontroller_index_path"
        namespace = "admin_index_path"
    end

    homeTitle = "Home"
    controllerTitle = controller.controller_name.capitalize
    actionTitle = controller.action_name.capitalize

    # Action Name Filters
    case actionTitle
      when 'Index'
        actionTitle = "Manage " + controllerTitle
      else
        actionTitle = actionTitle + ' ' + controllerTitle.singularize
    end

    options[:home]            ||= { :name => homeTitle, :link => user_signed_in? ? eval(namespace) : root_path }
    options[:controller]      ||= { :name => controllerTitle, :link => { :action => :index } }
    options[:action]          ||= { :name => actionTitle, :link => { :action => controller.action_name }}
    options[:entity]          ||= nil
    options[:filter]          ||= nil
    options[:span_size]       ||= 'span12'
    options[:container]       ||= false
    options[:divider]         ||= '/'
    options[:entity_divider]  ||= '::'
    options[:filter_divider]  ||= '::'
    options[:right_items]     ||= nil

    breadcrumbs = []
    # breadcrumbs << link_to( options[:home][:name], options[:home][:link] )
    breadcrumbs << link_to( "Site Administration", admin_index_path ) if controller.class.to_s.split("::").first == "Admin" || controller.class.to_s == "AdminController"
    breadcrumbs << link_to( options[:controller][:name], options[:controller][:link] ) unless controller.class.to_s == "AdminController"
    breadcrumbs << link_to( options[:action][:name], options[:action][:link] )

    options[:entity] = link_to( options[:entity][:name], options[:entity][:link] ) if options[:entity].present?

    render :partial => 'default/breadcrumbs',
           :locals => {
               :breadcrumbs       => breadcrumbs,
               :entity            => options[:entity],
               :filter            => options[:filter],
               :divider           => options[:divider],
               :entity_divider    => options[:entity_divider],
               :filter_divider    => options[:filter_divider],
               :span_size         => options[:span_size],
               :render_container  => options[:container],
               :right_items       => options[:right_items]
           }
  end

end