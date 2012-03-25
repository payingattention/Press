Press::Application.routes.draw do

  devise_for :users

  namespace :admin do
    resources :posts
    resources :users
    resources :import_wordpress
  end

  match 'admin/' => 'admin#index'
  match '/category/*category' => 'default#category'
  match '/tag/*tag' => 'default#tag'
  match '*seo_url' => 'default#show'

  root :to => 'default#index'

end
