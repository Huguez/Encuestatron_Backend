Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # devise_for :users
  
  namespace :v1 do

    resources :user
    # , only: [ :index ]
    # get '/user/', to: 'user#index'
    # get '/user/:id', to: 'user#show'

    resources :session, only: [ :create, :destroy ]

  end

end
