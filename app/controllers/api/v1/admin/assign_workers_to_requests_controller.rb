class Api::V1::Admin::AssignWorkersToRequestsController < Api::V1::Admin::ApplicationController
  before_action :set_request, only: [:assign_worker, :show, :unassign_worker]
  before_action :set_worker, only: [:assign_worker, :unassign_worker]	
  respond_to :json

  def show
  	respond_with @request
  end

  def assign_worker
    
    if @worker
  	  @request.workers << @worker

  	  # change status of worker from unassigned to assigned
  	  @worker.engage

  	  # change status of request from unresolved to resolved
  	  @request.resolve
      render json: @request, status: 200, location: [:api, :admin, @worker]
    end
  end

  def unassign_worker
  	if @worker
  	  @request.workers.delete(@worker)
  	  
  	  # change status of worker from assigned to unassigned
  	  @worker.disengage
  	  render json: @request, status: 200, location: [:api, :admin, @worker] 
  	end

  end


  private

  def set_request
    @request = Request.find(params[:id])
rescue ActiveRecord::RecordNotFound
	render json: { errors: "Record Not Found!" }, status: 404
  end

  def set_worker
  	@worker = Worker.find(params[:worker_id])
  rescue ActiveRecord::RecordNotFound
  	render json: { errors: "Record Not Found!" }, status: 404
  end

end
