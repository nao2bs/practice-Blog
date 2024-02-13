Rails.application.routes.draw do
  resources :posts, only: %i[index show] do
    resources :comments, only: %i[create destroy]
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"

  # http://localhost:3000
  root to: 'pages#index'

  # http://localhost:3000/pages/home
  get 'pages/home'
  get 'set_theme', to: 'theme#update'

  post '/pages/guest_sign_in', to: 'pages#new_guest'

  resources :notifications do
    member do
      put :mark_as_read
    end
  end

  resources :notifications, only: :index

end
