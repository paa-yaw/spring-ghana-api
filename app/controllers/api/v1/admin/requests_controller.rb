class Api::V1::Admin::RequestsController < Api::V1::Admin::ApplicationController
  respond_to :json

  def index
  	@requests = Request.search(params)
    respond_with @requests
  end
end
