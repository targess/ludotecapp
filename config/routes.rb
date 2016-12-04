Rails.application.routes.draw do

  # defaults to dashboard
  root :to => redirect('/singleview')
  
  # view routes
  get '/singleview' => 'singleview#index'
  
end
