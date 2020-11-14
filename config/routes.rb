Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#landing'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


  resources :communities do
    resources :message
  end

  resources :profiles, only: [ :show ]
  
  get 'home', to: 'pages#home'
  get 'results', to: 'pages#result'
  
end
