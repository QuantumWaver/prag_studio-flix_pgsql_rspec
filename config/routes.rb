Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: 'movies#index' # root_path or root_url

  # Routes for Movie model
  # mapping requests (type and resource) to a controller/action pair
  # get 'movies', to: 'movies#index'
  # get 'movies/:id', to: 'movies#show', as: 'movie'
  # get 'movies/:id/edit', to: 'movies#edit', as: 'edit_movie'
  # patch 'movies/:id', to: 'movies#update'

  # a singular resource, so no :id params needed in route
  get 'signin', to: 'sessions#new'
  resource :session, only: [:create, :destroy]

  # This will give us nested routes like:
  #  /movies/:movie_id/reviews
  resources :movies do
    resources :reviews, except: [:show]
  end

  get 'signup', to: 'users#new'
  resources :users, except: [:new]

end
