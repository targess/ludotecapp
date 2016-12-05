Rails.application.routes.draw do

  resources :boardgames

  # defaults to dashboard
  root :to => redirect('/singleview')

  # view routes
  get '/singleview' => 'singleview#index'

end
