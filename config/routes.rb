Rails.application.routes.draw do
  devise_for :users

  resources :events do
    scope module: "event" do
      patch "/boardgames/:id/add", to: "boardgames#add", as: "add_boardgame"
      patch "/boardgames/:id/del", to: "boardgames#del", as: "del_boardgame"
      resources :boardgames, only: [:index, :show]
      get "/players/show_by_dni", to: "players#show_by_dni"
      resources :players, except: [:new, :destroy]

      patch "/loans/:id", to: "loans#return"
      resources :loans, only: [:index, :create]

      resources :tournaments, except: [:new] do
        get :autocomplete_boardgame_name, on: :collection
        get :autocomplete_player_dni, on: :collection
        patch "/participants/:id/del", to: "tournaments#del", as: "del_participant"
        patch "/participants/:id/add", to: "tournaments#add", as: "add_participant"
        patch "/participants/:id/confirm", to: "tournaments#confirm", as: "confirm_participant"
      end
    end
  end

  namespace :admin do
    resources :players
    get  '/boardgames/import_from_bgg',         to: 'boardgames#import_from_bgg'
    post '/boardgames/create_from_bgg/:id', to: 'boardgames#create_from_bgg', as: 'boardgames_create_from_bgg'
    resources :boardgames
    resources :organizations
    resources :users
  end

  # defaults to dashboard
  root to: redirect("/events")
end
