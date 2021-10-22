
class V1::SessionController < ApplicationController

    # render :json => { :error => "parametros incompletos" }, :status => :bad_request
    # render json: @user, status: :created

    rescue_from ActionController::ParameterMissing do |exception|
        render :json => {:error => "Faltaron los parametros", :msg =>  exception.message }, :status => 422
    end

    # GET /session/login
    def login
        begin
            parametros = get_params
            _user = User.where( email: parametros["email"] ).first

            if _user.nil?
                render :json => { :ok => false, :error => "Usuario no Registrado" }, status: :unauthorized
                return
            end
            
            if _user&.valid_password?( parametros["password"] )
                x_token = JsonWebToken.encode( user_id: _user.id )
                render :json => { 
                    :ok => true,
                    :uidtkn => x_token, 
                    :user => _user.as_json( only: [ :id, :name, :email, :role ] ) }
                return
            else
                render :json => { :ok => false, :error => "Error If" }, status: :unauthorized
                return
                # head( :unauthorized ) # esto es equivalente a esto 'render status: :unauthorized
            end
        rescue  => e
            render json: {
                error: e.to_s
            }, status: :unprocessable_entity
            return
        end
    end

    # POST /session/register
    def register
        begin
            campos = [ "name", "email", "password", "role" ]
            parametros = get_params

            campos.each do |elem|
                if params["session"][elem].nil?
                    render :json => { :ok => false, :error => "parametros incompletos" }, :status => :bad_request
                    return
                end
            end

            user = User.new( parametros )
            if user.save
                x_token = JsonWebToken.encode( user_id: user.id )

                render :json => { 
                    :ok => true,
                    :user => user.as_json( only: [ :id, :name, :email, :role ] ),
                    :uidtkn => x_token }, 
                    :status => :created
                return
            else
                render :json => { :ok => false, :error => "Usuario ya Registrado" }, status: :unprocessable_entity
                return
            end
        rescue => e
            render json: {
                error: e.to_s
            }, status: :unprocessable_entity
            return
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
                    :uidtkn => x_token,
                    :ok => true
                }
                return
            rescue JWT::ExpiredSignature => e
                render json: {
                    error: e.to_s
                }, status: :unprocessable_entity
                return
            end
            
        else
            render :json => { :error => "No hay token" }, status: :unauthorized
            return
        end
    end

    private

    def get_params
        params.require('session').permit( [ "id", "name", "email", "password", "role" ] )
    end

end