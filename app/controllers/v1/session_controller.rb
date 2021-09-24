class V1::SessionController < ApplicationController

    # render :json => { :error => "parametros incompletos" }, :status => :bad_request
    # render json: @user, status: :created

    # POST /session/
    def create
        parametros = login_params
        user = User.where( email: parametros["email"] ).first
        if user&.valid_password?( parametros["password"] )
            render :json => { :toke => "Esto es un token", :user =>  user.as_json( only: [ :name, :email ] ) }
        else
            head( :unauthorized ) # esto es equivalente a esto # render status: :unauthorized
        end
    end

    # DELETE /session/:id
    def destroy
        render :json => { :resutl => "esto es una destroy" }
    end

    private

        def login_params
            # params.require('user').permit( [ "email", "password" ] )
            params.require('session').permit( [ "email", "password" ] )
        end

        def register_params
            puts "sign up"
        end
end