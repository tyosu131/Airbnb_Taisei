Rails.application.routes.draw do
  root 'pages#home'
  get '/about', to: 'pages#about'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resource :properties
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
