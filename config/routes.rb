Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root to: 'pages#landing'

  resources :communities, only: [:new, :create, :index, :show, :destroy ] do
    resources :messages
    resources :memberships, only: [:create]
    get :create_playlist
    get :add_track_playlist
  end

  resources :users, only: [:show, :index] do
    member do
      post :follow
      post :unfollow
    end
  end

  # resources :profiles, only: [ :show ]

  get 'home',    to: 'pages#home'
  get 'landing', to: 'pages#landing'
  get 'results', to: 'pages#result'
  get 'profile', to: 'pages#profile'

end
