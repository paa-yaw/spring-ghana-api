require 'rails_helper'

RSpec.describe Api::V1::Admin::ClientsController, type: :controller do

  before do
    @admin = FactoryGirl.create :client, admin: true 
  	api_authorization_headers @admin.auth_token
  end

  describe "GET #index" do

    context "admin can view all clients on application" do 
      before do 
        @clients = 5.times { FactoryGirl.create :client, admin: false }
        get :index
      end 

      it "returns a json response of all clients viewed by admin" do 
 	      expect(@clients).to eq 5	
      end

      it { should respond_with 200 }   
    end
  end

 describe "GET #show" do

   context "successful GET request"  do 
     before do 
       @client = FactoryGirl.create :client, admin: false
       get :show, id: @client.id
     end

     it "returns response in json" do 
       client_response = json_response[:client]
       expect(client_response[:email]).to eq @client.email
     end

     it { should respond_with 200 }
   end 

   context "unsuccessful GET request" do
     before do
       get :show, id: "some-id" 
     end 

     it "returns error in json response" do
       client_response = json_response
       expect(client_response).to have_key(:errors) 
     end

     it "returns reason for error in json response" do 
       client_response =json_response
       expect(client_response[:errors]).to eq "Record Not Found!"
     end

     it { should respond_with 404 }
   end
 end
end
