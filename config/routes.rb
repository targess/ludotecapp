Rails.application.routes.draw do
  devise_for :users

  resources :events do
    scope module: 'event' do
      resources :boardgames, only: [:index, :show, :update, :destroy]
      get "/players/show_by_dni", to: "players#show_by_dni"
      resources :players, except: [:new, :destroy]
      resources :loans, only: [:index, :create, :destroy]

      resources :tournaments, except: [:new] do
        resources :participants, only: [:create, :destroy, :update]
        get :autocomplete_boardgame_name, on: :collection
        get :autocomplete_player_dni, on: :collection
      end
    end
  end

  namespace :admin do
    resources :boardgames
    resources :organizations
    resources :players
    resources :users

    namespace :import do
      resources :bgg_boardgames, only: [:index, :create, :new]
      resources :bgg_collections, only: [:index, :create]
    end
  end

  # defaults to dashboard
  root to: redirect('/events')
end
