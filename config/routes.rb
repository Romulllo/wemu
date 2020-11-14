Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :communities do
    resources :messages
  end

  get 'landing_page', to: 'pages#search' do
    get 'results', to: 'pages#result'
  end

  resources :profiles, only: [:index, :show]
end
