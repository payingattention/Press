Press::Application.routes.draw do

  devise_for :users

  namespace :admin do
    resources :posts
    resources :users
    resources :tags
    resources :import_wordpress
  end
  # Admin route that gets us entry to the above namespace
  match 'admin/' => 'admin#index'
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
