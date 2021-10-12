class V1::EncuestaController < ApplicationController

    rescue_from ActionController::ParameterMissing do |exception|
        render :json => {:error => "Faltaron los parametros", :msg =>  exception.message }, :status => 422
    end

    before_action :authenticate

    #POST /encuesta/
    def create
        begin    
            aux = get_params
            aux["opciones"] = aux["opciones"].split(",")
            
            encuesta = Encuestum.new( aux )

            if encuesta.save
                render :json => { :ok => true, :encuesta => encuesta }, :status => :created
            else
                render json: encuesta.error, status: :unprocessable_entity
            end
        rescue => e
            render json: {
                error: e.to_s
            }, status: :unprocessable_entity
        end
    end

    #GET /encuesta/
    def index
        begin
        e = Encuestum.all
        render :json => { :encuestas => e, :ok => true  } , :status => :accepted
        rescue => e
            render json: {
                error: e.to_s
            }, status: :not_found
        end
    end

    #GET /encuesta/:id
    def show
        begin
            e = Encuestum.find( params["id"] )
            render :json => { :encuesta => e, :ok => true } , status: :accepted
        rescue ActiveRecord::RecordNotFound => e
            render json: {
                error: e.to_s
            }, status: :not_found
        end
    end

    # PUT /encuesta/:id
    def update
        begin
            encuesta = Encuestum.find( params["id"] )
            if encuesta.update( user_params )
                render :json => { :ok => true, :encuesta => encuesta }, status: :accepted
            else
                render json: encuesta.error, status: :unprocessable_entity
            end
        rescue ActiveRecord::RecordNotFound => e
            render json: {
                error: e.to_s
            }, status: :not_found 
        end
    end

    # DELETE /encuesta/:id
    def destroy
        begin
            e = Encuestum.find( params["id"] )
            if e.destroy
                render :json => { :encuesta => e, :ok => true }, status: :accepted
            end
        rescue  ActiveRecord::RecordNotFound => e
            render json: {
                error: e.to_s
            }, status: :not_found
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

    def get_params
        # :name, :email, :password, :role 
        params.require("encuestum").permit( [ "titulo", "descripcion", "opciones", "activo", "id_user_creator" ] )
    end
end
