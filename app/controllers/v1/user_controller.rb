class V1::UserController < ApplicationController
    
    rescue_from ActionController::ParameterMissing do |exception|
        render :json => {:error => exception.message, :msg => "Faltaron los parametros" }, :status => 422
    end

    before_action :authenticate
    

    # POST /user/
    def create
        begin
            @campos = [ "name", "email", "password", "role" ]
            
            @campos.each do |elem|
                if params["user"][elem].nil?
                    render :json => { :error => "parametros incompletos" }, :status => :bad_request
                end
            end
            
            @user = User.new( user_params )
            if @user.save
                # render :json => { :user => @user, :token => "wawa" }, :status => :created
                render :json => { :user => @user }, :status => :created
            else
                render json: @user.error, status: :unprocessable_entity
            end 
        rescue => e
            render json: {
                error: e.to_s
            }, status: :unprocessable_entity
        end
    end    
    
    # GET /user/
    def index
        auxArray = Array.wrap(nil)
        User.all.each do |u|
            a = u.as_json( only: [ "id", "name", "email", "role", ] )
            auxArray.push( a )
        end

        render json: auxArray
    end
    
    # GET /user/:id
    def show
        begin
            @user = User.find(params[:id])
            render json: @user, status: :ok
        rescue ActiveRecord::RecordNotFound => e
            render json: {
                error: e.to_s
            }, status: :not_found
        end
    end
    
    # PUT/PATH /user/:id
    def update
        begin
            @user = User.find(params[:id])
            if @user.update( user_params )
                render json: @user, status: :ok
            else
                render json: @user.error, status: :unprocessable_entity
            end
        rescue ActiveRecord::RecordNotFound => e
            render json: {
                error: e.to_s
            }, status: :not_found
        end
    end

    # DELETE /user/:id
    def destroy
        begin
            @user = User.find( params[:id] )
            if @user.destroy
                render json: @user, status: :ok
            end
        
        rescue ActiveRecord::RecordNotFound => e
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

    def user_params
        # :name, :email, :password, :role 
        params.require("user").permit( [ "name", "email", "password", "role" ] )
    end
end
