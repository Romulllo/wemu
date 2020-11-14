Rails.application.routes.draw do
  devise_for :users

  root to: 'pages#landing'

  resources :communities do
    resources :message
  end

  resources :profiles, only: [ :show ]
  
  get 'home', to: 'pages#home'
  get 'results', to: 'pages#result'
  
end
