class Api::V1::Admin::ApplicationController < ApplicationController
  respond_to :json
  before_action :authorize_admin!


  private 


  def authorize_admin!
    authenticate_with_token!

    render json: { errors: "You must have admin priviledges to be allowed!" }, status: 401 unless current_client.admin?
  end
end
