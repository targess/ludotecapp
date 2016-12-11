Rails.application.routes.draw do

  resources :events do
    get   '/players/show_by_dni', to: 'players#show_by_dni'
    resources :players, except: [ :new, :destroy ]

    patch '/loans/:id', to: 'loans#return'
    resources :loans, only: [ :index, :create ]
    patch '/boardgames/:id/add', to: 'boardgames#add', as: 'add_boardgame'
    patch '/boardgames/:id/del', to: 'boardgames#del', as: 'del_boardgame'
    resources :boardgames, only: [ :index, :show ]
  end

  namespace :admin do
    resources :players
    resources :boardgames
  end

  # defaults to dashboard
  root :to => redirect('/events')

end
