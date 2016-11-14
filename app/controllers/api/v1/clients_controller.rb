class Api::V1::ClientsController < ApplicationController
  before_action :set_client, only: [:show, :update]
  before_action :authenticate_with_token!, only: [:update, :destroy]
  respond_to :json

  def show
  	respond_with set_client
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      render json: @client, status:  201, location: [:api, @client]
      ClientMailer.send_signup_alert(@client)
      # send sms
    else
      render json: { errors: @client.errors }, status: 422
    end 
  end

  def update
    @client = current_client

  	if @client.update(client_params)
      render json: @client, status: 200, location: [:api, @client]
    else
      render json: { errors: @client.errors }, status: 422
  	end    
  end

  def destroy
  	@client = current_client
  	@client.destroy
  	head 204
    # send email
    # send sms
  end



  private

  def client_params
    params.require(:client).permit(:email, :password, :password_confirmation, :first_name, :last_name, :location, :auth_token, :admin)
  end

  def set_client
    @client = Client.find(params[:id])	
rescue ActiveRecord::RecordNotFound
	render json: { errors: "client record can't be found" }, status: 404
  end
end
