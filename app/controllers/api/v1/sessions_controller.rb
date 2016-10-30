class Api::V1::SessionsController < ApplicationController
  respond_to :json

  def create 
    client_email = params[:session][:email]
    client_password = params[:session][:password]

    client = client_email.present? && Client.find_by(email: client_email)

    if client.valid_password? client_password
      sign_in client
      client.generate_auth_token!
      client.save
      render json: client, status: 200, location: [:api, client]
    else
      render json: { errors: "Invalid email or password" }, status: 422	
    end
  end

  def destroy
  	client = Client.find_by(auth_token: params[:id])
    client.generate_auth_token!
    client.save
  	head 204
  end
end
