Rails.application.routes.draw do

  resources :events do
    get '/players/show_by_dni', to: 'players#show_by_dni'
    resources :players
    resources :loans
    resources :boardgames
  end

  namespace :admin do
    resources :players
    resources :boardgames
  end

  # defaults to dashboard
  root :to => redirect('/singleview')

  # view routes
  get '/singleview' => 'singleview#index'

end
