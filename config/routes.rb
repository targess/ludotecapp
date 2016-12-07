Rails.application.routes.draw do

  resources :events do
    resources :loans
  end

  resources :players
  resources :boardgames

  # defaults to dashboard
  root :to => redirect('/singleview')

  # view routes
  get '/singleview' => 'singleview#index'

end
