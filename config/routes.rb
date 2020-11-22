Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root to: 'pages#landing'

  resources :communities do
    resources :messages
  end

  # resources :profiles, only: [ :show ]

  get 'home',    to: 'pages#home'
  get 'landing', to: 'pages#landing'
  get 'results', to: 'pages#result'
  get 'profile', to: 'pages#profile'

end
