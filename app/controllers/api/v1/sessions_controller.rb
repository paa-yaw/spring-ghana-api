class Api::V1::SessionsController < ApplicationController
  respond_to :json

 
  def create 
    @password = params[:session][:password]
    @email = params[:session][:email]


    @user = @email.present? && (Client.find_by(email: @email) || Worker.find_by(email: @email))
    
    if @user.class == Client
      if @user.valid_password? @password || @email.present?
        sign_in @user
        @user.generate_auth_token!
        @user.save
        render json: @user, status: 200, location: [:api, @user]
      else
        render json: { errors: "Invalid email or password" }, status: 422 
      end
    elsif @user.class == Worker
      if worker_authenticated?(@user, @password)
        # sign_in @user
        session[:worker_id] = @user.id
        @user.generate_auth_token!
        @user.save
        render json: @user, status: 200, location: [:api, @user]
      else
        render json: { errors: "Invalid email or password" }, status: 422 
      end
    end
  end


  def destroy
    user = Client.find_by(auth_token: params[:id]) || Worker.find_by(auth_token: params[:id])
    user.generate_auth_token!
    user.save
    head 204
  end
end


private 


def worker_authenticated?(user, password)
  if user.authenticate(password)
    return true
  else
    return false
  end
end