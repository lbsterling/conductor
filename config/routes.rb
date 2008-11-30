ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.resources :users
    admin.root :controller => 'users'
  end
  
  map.resource :account, :controller => 'users'
  map.resources :activations
  map.resources :passwords
  map.resources :users
  map.resource :session, :controller => 'user_sessions'

  map.root :controller => 'pages', :action => 'index'
  
  map.connect ':action.:format', :controller => 'pages'
  map.connect ':action', :controller => 'pages'
end
