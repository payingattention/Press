Press::Application.routes.draw do

  devise_for :users


  namespace :admin do
    resources :posts
    resources :users
    resources :import_wordpress
  end

  match 'admin/' => 'admin#index'

  root :to => 'default#index'

end
