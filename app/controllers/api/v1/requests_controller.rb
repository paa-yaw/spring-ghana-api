class Api::V1::RequestsController < ApplicationController
  before_action :authenticate_with_token!
  before_action :set_request, only: [:show, :update, :destroy]
  respond_to :json

  def index
    @requests = current_client.requests.all
    render json: @requests, status: 200
  end

  def show
  	respond_with set_request
  end

  def create
  	@request = current_client.requests.build(request_params)

  	if @request.save
  	  render json: @request, status: 201, location: [:api, @request]
      # send email
      # send sms
  	else
  	  render json: { errors: @request.errors }, status: 422
  	end
  end

  def update
    if @request.update(request_params)
      render json: @request, status: 200, location: [:api, @request]
    else
      render json: { errors: @request.errors }, status: 422
    end
  end

  def destroy
  	@request.destroy
  	head 204
  end


  private

  def set_request
  	@request = current_client.requests.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    render json: { errors: "Record Not Found"}, status: 404
  end

  # def set_client
  #   @client = Client.find(params[:client_id])
  # end

  def request_params
    params.require(:request).permit(:bedrooms, :bathrooms, :kitchens, :living_rooms, :time_of_arrival, :schedule)
  end
end
