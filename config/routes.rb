Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :v1 do
    resources :user
    
    # get '/user/', to: 'user#index'
    # get '/user/:id', to: 'user#show'

  end

end
