class Api::V1::ClientsController < ApplicationController
  before_action :set_client, only: [:show]
  respond_to :json

  def show
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      render json: @client, status:  201, location: [:api, @client]
    else
      render json: { errors: @client.errors }, status: 422
    end 
  end


  private

  def client_params
    params.require(:client).permit(:email, :password, :password_confirmation, :first_name, :last_name, :location, :admin, :auth_token)
  end

  def set_client
    respond_with @client = Client.find(params[:id])	
rescue ActiveRecord::RecordNotFound
	render json: { errors: "client record can't be found" }, status: 404
  end
end
