Rails.application.routes.draw do
  root 'pages#home'
  get '/about', to: 'pages#about'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :properties, only: [:index, :show]

  namespace :host do
    resources :properties do
      resources :images, only: [:create, :destroy]

      member do
        get :listing
        get :pricing
        get :description
        get :images
        get :amenities
        get :location
      end
    end
  end

  get 'user/:id/show', to: 'users#show', as: 'user'
end
