class Api::V1::Admin::AssignWorkersToRequestsController < Api::V1::Admin::ApplicationController
  before_action :set_request, only: [:assign_worker, :show]	
  respond_to :json

  def show
  	respond_with @request
  end

  def assign_worker
  	@worker = Worker.find(params[:worker_id])

  	@request.workers << @worker

  	# change status of worker from unassigned to assigned
  	@worker.engage

  	# change status of request from unresolved to resolved
  	@request.resolve

  	if @request.workers.include? @worker
      render json: @request, status: 200, location: [:api, :admin, @request]
    else
      render json: { errors: "could not assign worker" }, status: 422
    end
  end


  private

  def set_request
    @request = Request.find(params[:id])
rescue ActiveRecord::RecordNotFound
	render json: { errors: "Record Not Found!" }, status: 404
  end

end