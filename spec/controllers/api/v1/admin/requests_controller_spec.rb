require 'rails_helper'

RSpec.describe Api::V1::Admin::RequestsController, type: :controller do
  before do 
  	@admin = FactoryGirl.create :client, admin: true
    api_authorization_headers @admin.auth_token
  end
  
  describe "GET #index" do 
  	before do 
  	  4.times { FactoryGirl.create :request }	
  	  get :index
  	end

  	context "admin can view all requests" do 
      it "returns response as json" do 
      	requests_response = json_response[:requests]
      	# expect(requests_response).to have(4).items
      end

      it "returns 4 requests" do 
      	expect(Request.count).to eq 4
      end
  	end
  end
end
