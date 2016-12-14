Rails.application.routes.draw do

  resources :events do
    get   '/players/show_by_dni', to: 'players#show_by_dni'
    resources :players, except: [ :new, :destroy ]

    patch '/loans/:id', to: 'loans#return'
    resources :loans, only: [ :index, :create ]
    patch '/boardgames/:id/add', to: 'boardgames#add', as: 'add_boardgame'
    patch '/boardgames/:id/del', to: 'boardgames#del', as: 'del_boardgame'
    resources :boardgames, only: [ :index, :show ]
    resources :tournaments, except: [:new] do
      get :autocomplete_boardgame_name, :on => :collection
      get :autocomplete_player_dni, :on => :collection
      patch '/participants/:id/del', to: 'tournaments#del', as: 'del_participant'
      patch '/participants/:id/add', to: 'tournaments#add', as: 'add_participant'

    end

  end

  namespace :admin do
    resources :players
    get  '/boardgames/import_from_bgg',         to: 'boardgames#import_from_bgg'
    post '/boardgames/create_from_bgg/:id', to: 'boardgames#create_from_bgg', as: 'boardgames_create_from_bgg'
    resources :boardgames
  end

  # defaults to dashboard
  root :to => redirect('/events')

end
