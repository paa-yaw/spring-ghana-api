class Api::V1::Admin::RequestsController < Api::V1::Admin::ApplicationController
  respond_to :json
  before_action :set_request, only: [:show]
  before_action :set_client, only: [:create]


  def index
  	@requests = Request.search(params)
    respond_with @requests
  end

  def show
  	respond_with @request
  end

  def create
  	@request = @client.requests.build(request_params)

  	if @request.save
  	  render json: @request, status: 201, location: [:api, :admin, @request]
  	else
  	  render json: { errors: @request.errors }, status: 422
  	end
  end


  private

  def request_params
    params.require(:request).permit(:bedrooms, :bathrooms, :kitchens, :living_rooms, :time_of_arrival, :schedule)
  end

  def set_request
  	@request = Request.find(params[:id])
  rescue ActiveRecord::RecordNotFound
  	render json: { errors: "Record Not Found!" }, status: 404
  end

  def set_client
  	@client = Client.find(params[:client_id])
  end
end
