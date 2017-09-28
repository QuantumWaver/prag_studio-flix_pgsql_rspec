Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: 'movies#index' # root_path or root_url

  # a singular resource, so no :id params needed in route
  get 'signin', to: 'sessions#new'
  resource :session, only: [:create, :destroy]


  # To send routes to the 'index' action in the Movies controller
  # with a variable in params ':scope' so that you could display
  # different lists of movies, there are three possible ways:
  # 1. to declare literal routes and place a variable in the params hash:
        # get "movies/hits", to: "movies#index", scope: "hits"
        # get "movies/flops", to: "movies#index", scope: "flops"
        # get "movies/upcoming", to: "movies#index", scope: "upcoming"
        # get "movies/recent", to: "movies#index", scope: "recent"
  # 2. You could use a constraint on the variable with a regular expression:
        # get 'movies/:scope', to: "movies#index",
        #    constraints: { scope: /hits|flops|upcoming|recent/ }, as: :filtered_movies
  # 3. You could make a different literal route route:
        # get 'movies/filter/:scope', to: 'movies#index', as: 'filtered_movies'
  # I like 2, as it makes the URL look better and is not all that hard to maintain
  get 'movies/:scope', to: "movies#index",
      constraints: { scope: MoviesController::MOVIES_INDEX_SCOPE }, as: :filtered_movies

  # This will give us nested routes like:
  #  /movies/:movie_id/reviews
  resources :movies do
    resources :reviews, except: [:show]
    resources :favorites, only: [:create, :destroy]
  end

  get 'signup', to: 'users#new'
  resources :users, except: [:new]

  resources :genres

end
