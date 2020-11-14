Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root to: 'pages#landing'

  resources :communities do
    resources :message
  end

  resources :profiles, only: [ :show ]
  
  get 'home', to: 'pages#home'
  get 'results', to: 'pages#result'
  
end
