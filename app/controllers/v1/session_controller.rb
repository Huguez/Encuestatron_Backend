
class V1::SessionController < ApplicationController

    # render :json => { :error => "parametros incompletos" }, :status => :bad_request
    # render json: @user, status: :created

    # GET /session/login
    def login
        begin    
            parametros = get_params
            # parametros = params #.require('user').permit( [ "id", "name", "email", "password", "role" ] )
            # render :json => { :error => parametros }
            _user = User.where( email: parametros["email"] ).first
            x_token = JsonWebToken.encode( user_id: _user.id )
            
            if _user&.valid_password?( parametros["password"] )
                render :json => { 
                    :uidtkn => x_token, 
                    :user => _user.as_json( only: [ :id, :name, :email, :role ] ) }
            else
                head( :unauthorized ) # esto es equivalente a esto 'render status: :unauthorized'
            end
        rescue  => e
            render json: {
                error: e.to_s
            }, status: :unprocessable_entity
        end
    end

    # POST /session/register
    def register
        begin
            campos = [ "name", "email", "password", "role" ]
            parametros = get_params

            campos.each do |elem|
                if params["session"][elem].nil?
                    render :json => { :error => "parametros incompletos" }, :status => :bad_request
                end
            end
            user = User.new( parametros )
            if user.save
                x_token = JsonWebToken.encode( user_id: user.id )
                # render :json => { :aux => parametros }
                render :json => { 
                    :user => user.as_json( only: [ :id, :name, :email, :role ] ),
                    :uidtkn => x_token }, 
                    :status => :created
            else
                render json: user.errors, status: :unprocessable_entity
            end
        rescue => e
            render json: {
                error: e.to_s
            }, status: :unprocessable_entity
        end
    end 

    # GET /session/renew
    def renew
        # "Hello #{@name}"
        if request.headers['uidtkn']
            begin
                x_token = request.headers['uidtkn'].split(' ').last
                resp = JsonWebToken.decode( x_token )
                
                aux = resp.as_json()
                user_id = aux["user_id"];
                _user = User.where( id: user_id ).first
                
                x_token = JsonWebToken.encode( user_id: _user.id )
    
                render :json => { 
                    :user => _user.as_json( only: [ :id, :name, :email, :role ] ),
                    :uidtkn => x_token
                }
            rescue => e
                render json: {
                    error: e.to_s
                }, status: :unprocessable_entity
            end
            
        else
            render :json => { :error => "No hay token" }, status: :unauthorized
        end
    end


    private

        def get_params
            
            params.require('session').permit( [ "id", "name", "email", "password", "role" ] )
        end
end