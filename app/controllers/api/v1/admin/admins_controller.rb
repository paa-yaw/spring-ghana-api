class Api::V1::Admin::AdminsController < Api::V1::Admin::ApplicationController
  respond_to :json

  def index
    @clients = Client.where(admin: false)
    respond_with @clients	
  end
end
