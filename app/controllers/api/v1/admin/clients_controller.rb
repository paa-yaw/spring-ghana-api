class Api::V1::Admin::ClientsController < Api::V1::Admin::ApplicationController
  before_action :set_client, only: [:show]
  respond_to :json

  def index
    @clients = Client.where(admin: false)
    respond_with @clients	
  end

  def show
  	respond_with @client
  end


  private

  def set_client
  	@client = Client.find(params[:id])
  rescue ActiveRecord::RecordNotFound
  	render json: { errors: "Record Not Found!" }, status: 404
  end
end
