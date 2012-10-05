Press::Application.routes.draw do

  # Routes for devise users (login logout register..etc)
  devise_for :users, :path => '', :path_names => {
      :sign_in => 'login',
      :sign_out => 'logout',          # must be method :DELETE
      :registration => 'register',    # /register POST
      :sign_up => 'new'               # /register/new
  }

  # Below we define all of our administrator namespace routes.. These are for site admin and site staff members only
  resources :admin, :only => [ :index ]
  namespace :admin do
    resources :content,  :path => ":type", :constraints => { :type => /posts|pages|comments|messages|ads|blocks/ }, :only => [ :index ]
    resources :content,   :path => ":type", :constraints => { :type => /post|page|comment|message|ad|block/ }, :only => [ :edit ]
    # The following are crud for content types
    resources :posts,     :except => [ :index, :show ]
    resources :pages,     :except => [ :index, :show ]
    resources :comments,  :except => [ :index, :show ]
    resources :messages,  :except => [ :index, :show ]
    resources :ads,       :except => [ :index, :show ]
    resources :blocks,    :except => [ :index, :show ]

    resources :users
    resources :taxonomies
    resources :layouts
    resources :widgets
    resources :import_wordpress, :only => [ :new, :create ]

    # Site settings :index for showing the form and :create to post it (though not technically correct)
    resources :settings, :only => [ :index, :create ]
    namespace :settings do
      resources :content, :only => [ :index, :create ]
    end

    # Site tools
    resources :tools, :only => [ :index ]
    namespace :tools do
      resources :software_update, :only => [ :index ] do
        collection do
          get :upgrade, :path => "upgrade"
        end
      end
    end

  end

  # Installation Routes -- @TODO How do we delete this routing entirely after site is installed?
  resources :install, :only => [ :index, :create_owner ] do
    collection do
      post :create_owner, :path => "create_owner"
    end
  end

  # Below I am adding some custom routes to match what wordpress does.
  # I don't know if this is the correct way to add these or not, but they work

  # Category route similar to wordpress
  match '/category/*category' => 'default#category', :as => 'category'
  # Tag route similar to wordpress
  match '/tag/*tag' => 'default#tag', :as => 'tag'
  # Page route which gets us pages deeper into the main index page list, not related to content :pages
  match '/page/*page' => 'default#index', :as => 'page'
  # Default SEO URL (Permalink) route for showing pages and posts
  match '*seo_url' => 'default#show', :as => 'slug'
  # Default
  root :to => 'default#index'

end
