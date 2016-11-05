class Api::V1::Admin::WorkersController < Api::V1::Admin::ApplicationController
  before_action :set_worker, only: [:show, :update, :destroy]
  respond_to :json

  def index
  	@workers = Worker.all
  	respond_with @workers
  end

  def show
    respond_with @worker
  end

   def create
  	@worker = Worker.new(worker_params)

  	if @worker.save
  	  render json: @worker, status: 201, location: [:api, :admin, @worker]	
  	else
  	  render json: { errors: @worker.errors }, status: 422
  	end
  end

  def update
    if @worker.update(worker_params)
      render json: @worker, status: 200, location: [:api, :admin, @worker]
    else
      render json: { errors: @worker.errors }, status: 422	
    end	
  end

  def destroy
  	@worker.destroy
  	head 204
  end



  private

  def worker_params
  	params.require(:worker).permit(:first_name, :last_name, :age, :sex, :phone_number, :location, :experience, :min_wage, :email, 
  	:password, :password_confirmation, :auth_token)
  end

  def set_worker
    @worker = Worker.find(params[:id])
rescue ActiveRecord::RecordNotFound
	render json: { errors: "Record Not Found!" }, status: 404
  end
end
