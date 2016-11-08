module Authenticable
  def current_client
  	@current_client ||= Client.find_by(auth_token: request.headers["Authorization"])
  end

  def client_signed_in?
    current_client.present?
  end



  def current_admin
    @current_admin ||= Client.find_by(auth_token: request.headers["Authorization"], admin: true) 
  end

  def admin_signed_in?
    current_admin.present?
  end



  def current_worker
    @current_worker ||= Worker.find_by(auth_token: request.headers["Authorization"])
  end

  def worker_signed_in?
    current_worker.present?
  end






  def authenticate_worker_with_token!
    render json: { errors: "Not Authenticated!" }, status: 401 unless worker_signed_in? 
  end

  def authenticate_with_token_and_authorize!
    render json: { errors: "You must have admin priviledges to be allowed!" }, status: 401 unless admin_signed_in?
  end

  def authenticate_with_token!
  	render json: { errors: "Not Authenticated!" }, status: 401 unless client_signed_in?
  end
end