class V1::SessionController < ApplicationController

    # render :json => { :error => "parametros incompletos" }, :status => :bad_request
    # render json: @user, status: :created

    # POST /session/
    def create
        parametros = login_params
        user = User.where( email: parametros["email"] ).first
        x_token = JsonWebToken.encode( user_id: user.id )
        
        if user&.valid_password?( parametros["password"] )
            render :json => { :uidtkn => x_token, :user =>  user.as_json( only: [ :name, :email, :role ] ) }
        else
            head( :unauthorized ) # esto es equivalente a esto # render status: :unauthorized
        end
    end

    private

        def login_params
            # params.require('user').permit( [ "email", "password" ] )
            params.require('session').permit( [ "email", "password" ] )
        end
end