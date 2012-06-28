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
    resources :posts
    resources :users
    resources :taxonomies
    resources :import_wordpress
  end
  # Category route similar to wordpress
  match '/category/*category' => 'default#category'
  # Tag route similar to wordpress
  match '/tag/*tag' => 'default#tag'
  # Page route which gets us deeper into the main index page
  match '/page/*page' => 'default#index'
  # Default SEO URL (Permalink) route for showing pages and posts
  match '*seo_url' => 'default#show'
  # Default
  root :to => 'default#index'

end
