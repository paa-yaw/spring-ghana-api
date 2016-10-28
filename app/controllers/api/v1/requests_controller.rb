class Api::V1::RequestsController < ApplicationController
  before_action :set_request, only: [:show]
  respond_to :json

  def show
  	respond_with set_request
  end


  private

  def set_request
  	@request = Request.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    render json: { errors: "Record Not Found"}, status: 404
  end
end
