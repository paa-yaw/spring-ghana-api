require 'rails_helper'

RSpec.describe Api::V1::Admin::AdminsController, type: :controller do

  before do
    @admin = FactoryGirl.create :client, admin: true 
  	api_authorization_headers @admin.auth_token
  end

  describe "GET #index" do

    context "admin can view all clients on application" do 
      before do 
        @clients = 5.times { FactoryGirl.create :client, admin: false }
        get :index, id: @admin.id 
      end 

      it "returns a json response of all clients viewed by admin" do 
 	    expect(@clients).to eq 5	
      end

      it { should respond_with 200 }   
    end
  end

end
