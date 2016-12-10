Rails.application.routes.draw do

  resources :events do
    get   '/players/show_by_dni', to: 'players#show_by_dni'
    resources :players, except: [ :new, :destroy ]

    patch '/loans/:id', to: 'loans#return'
    resources :loans, only: [ :index, :create ]
    resources :boardgames
  end

  namespace :admin do
    resources :players
    resources :boardgames
  end

  # defaults to dashboard
  root :to => redirect('/events')

end
