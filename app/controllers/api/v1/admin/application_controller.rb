class Api::V1::Admin::ApplicationController < ApplicationController
  respond_to :json
  before_action :authorize_admin!


  private 


  def authorize_admin!	
    authenticate_with_token_and_authorize!
  end
end
