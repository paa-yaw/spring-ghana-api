class Api::V1::RequestsController < ApplicationController
  before_action :set_request, only: [:show]
  respond_to :json

  def show
  	respond_with set_request
  end

  def create
  	@request = Request.new(request_params)

  	if @request.save
  	  render json: @request, status: 201, location: [:api, @request]
  	else
  	  render json: { errors: @request.errors }, status: 422
  	end
  end


  private

  def set_request
  	@request = Request.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    render json: { errors: "Record Not Found"}, status: 404
  end

  def request_params
    params.require(:request).permit(:bedrooms, :bathrooms, :kitchens, :living_rooms, :time_of_arrival, :schedule)
  end
end
