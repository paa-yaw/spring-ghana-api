module Authenticable
  def current_client
  	@current_client ||= Client.find_by(auth_token: request.headers["Authorization"])
  end

  def current_admin
    @current_admin ||= Client.find_by(auth_token: request.headers["Authorization"], admin: true)
  end

  def current_worker
    @current_worker ||= Worker.find_by(auth_token: request.headers["Authorization"])
  end

  def authenticate_worker_with_token!
    render json: { errors: "Not Authenticated!" }, status: 401 unless current_worker.present? 
  end

  def authenticate_with_token_and_authorize!
    render json: { errors: "You must have admin priviledges to be allowed!" }, status: 401 unless current_client && current_admin
  end

  def authenticate_with_token!
  	render json: { errors: "Not Authenticated!" }, status: 401 unless current_client.present?
  end
end