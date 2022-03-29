Rails.application.routes.draw do
  root 'pages#home'
  get '/about', to: 'pages#about'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :properties do
    member do
      get 'listing', 'pricing', 'description', 'images', 'amenities', 'location'
    end
    resources :images, only: [:create, :destroy]
  end
  

  get 'user/:id/show', to: 'users#show', as: 'user' #path name

  resources :properties do
    member do
      get 'images'
    end
    resources :images, only: [:create, :destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
