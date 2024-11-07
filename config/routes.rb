Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :posts, only: %i[index show] do
    resources :comments, only: %i[create destroy]
  end

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"

  # http://localhost:3000
  # root to: 'pages#home'
  root to: 'posts#index'

  get 'set_theme', to: 'theme#update'

  post '/pages/guest_sign_in', to: 'pages#new_guest'
end
