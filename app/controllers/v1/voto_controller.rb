class V1::VotoController < ApplicationController

    rescue_from ActionController::ParameterMissing do |exception|
        render :json => { :error => "Faltaron los parametros", :msg =>  exception.message }, :status => 422
    end

    before_action :authenticate

    # GET /voto/
    def index
        begin
            voto = Voto.all
            render :json => { :voto => voto, :ok => true  }, :status => :accepted
        rescue => e
            render json: {
                error: e.to_s
            }, status: :unprocessable_entity
        end
    end

    # POST /voto/
    def create
        begin
            campos = [ "opcion", "id_votante", "id_encuesta" ]
            
            if params[:voto].nil?
                render :json => { :error => "Faltaron los parametros" }, :status => :bad_request
                return
            end

            campos.each do |elem|
                if params[:voto][elem].nil?
                    render :json => { :error => "parametros incompletos" }, :status => :bad_request
                    return
                end
            end
            
            voto = Voto.new( voto_params )
            if voto.save
                render :json => { :votos => voto, :ok => true  }, :status => :created
                return
            else
                render json: voto.error, status: :unprocessable_entity
                return
            end 
        rescue => e
            render json: {
                error: e.to_s
            }, status: :unprocessable_entity
        end
    end

    # DELETE /voto/:id
    def destroy
        begin
            v = Voto.find( params["id"] )
            if v.destroy
                render :json => { :voto => v, :ok => true }, status: :accepted
            end
        rescue  ActiveRecord::RecordNotFound => e
            render json: {
                error: e.to_s
            }, status: :not_found
        end
    end

    def voto_usuario
        render :json => { :prueba => "voto_usuario" }, status: :accepted
    end

    def voto_encuesta
        render :json => { :prueba => "voto_encuesta" }, status: :accepted
    end
    
    def voto_asoc
        begin
            id_user = params[:id_user]
            id_encuesta = params[:id_survey]
            condicion = ["id_votante = ? and id_encuesta = ? ",id_user, id_encuesta ]
            vote = Voto.where( condicion )
            if( vote.length > 0 )
                render :json => { :voto => vote.first, :ok => true }, status: :accepted
            else
                render :json => { :ok => false }, status: :accepted
            end

        rescue ActiveRecord::ActiveRecordError => exception
            render json: {
                error: e.to_s
            }, status: :unprocessable_entity 
        end
    end

    private

    def authenticate
        if request.headers['uidtkn']
            x_token = request.headers['uidtkn'].split(' ').last
            resp = JsonWebToken.decode( x_token )
            render :json => { :error => "Token invalido" }, status: :unauthorized unless resp[ "user_id" ]
            return if resp
        else
            render :json => { :error => "No hay token" }, status: :unauthorized
        end
    end

    def voto_params
        return params.require("voto").permit( [ "opcion", "id_votante", "id_encuesta" ] )
    end

end
