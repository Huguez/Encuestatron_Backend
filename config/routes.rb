Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  namespace :v1 do

    #:only [ creara solo estas rutas especificas ]
    #except: [ lsta de rutas que no se deben crear ]
    resources :user
    resources :encuesta    
    resources :voto, only: [ :create, :index, :destroy ]

    # votos routes implicitos 
    match '/voto/usuario/:id_user'         => 'voto#voto_usuario',  :via => :get
    match '/voto/encuesta/:id_survey'      => 'voto#voto_encuesta', :via => :get
    match '/voto/asoc/:id_user/:id_survey' => 'voto#voto_asoc',     :via => :get

    # session routes implicitos
    match '/session/login'    => 'session#login',    :via => :post
    match '/session/register' => 'session#register', :via => :post
    match '/session/renew'    => 'session#renew',    :via => :get

  end

end
