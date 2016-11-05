class Api::V1::Admin::ClientsController < Api::V1::Admin::ApplicationController
  before_action :set_client, only: [:show, :update, :destroy]
  respond_to :json

  def index
    @clients = Client.where(admin: false)
    respond_with @clients	
  end

  def show
  	respond_with @client
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      render json: @client, status: 201, location: [:api, :admin, @client]
    else
      render json: { errors: @client.errors }, status: 422	
    end
  end

  def update
  	if @client.update(client_params)
      render json: @client, status: 200, location: [:api, :admin, @client]
    else
      render json: { errors: @client.errors }, status: 422
  	end
  end

  def destroy
  	@client.destroy
  	head 204
  end



  private

  def client_params
  	params.require(:client).permit(:email, :password, :password_confirmation, :first_name, :last_name, :location, :auth_token, :admin)
  end

  def set_client
  	@client = Client.find(params[:id])
  rescue ActiveRecord::RecordNotFound
  	render json: { errors: "Record Not Found!" }, status: 404
  end
end
