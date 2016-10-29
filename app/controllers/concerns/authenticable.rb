module Authenticable
  def current_client
  	@current_client ||= Client.find_by(auth_token: request.headers["Authorization"])
  end

  def authenticate_with_token!
  	render json: { errors: "Not Authenticated!" }, status: 401 unless current_client.present?
  end
end