Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # devise_for :users
  
  namespace :v1 do

    resources :user
    # :exxcept => [], :only => [ :index ]
    # get '/user/', to: 'user#index'
    
    # resources :session

    match '/session/login' => 'session#login', :via => :post
    match '/session/register' => 'session#register', :via => :post
    match '/session/renew' => 'session#renew', :via => :get

  end

end
