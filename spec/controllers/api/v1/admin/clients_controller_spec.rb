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

      it "returns response in json" do 
        client_response = json_response[:clients]
        expect(client_response).to have(5).items
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

 describe "POST #create" do

   context "successfully" do 
     before do
       @client_attributes = FactoryGirl.attributes_for :client
       post :create, { client: @client_attributes } 
     end 

     it "returns response in json" do
       client_response = json_response[:client]
       expect(client_response[:email]).to eq @client_attributes[:email] 
     end

     it { should respond_with 201 }
   end

   context "unsuccessfully" do 
     before do 
       @client_attributes = FactoryGirl.attributes_for :client
       @client_attributes[:email] = ""
       @invalid_attributes = @client_attributes    
       post :create, { client: @invalid_attributes }
     end

     it "returns error in json response" do 
       client_response = json_response
       expect(client_response).to have_key(:errors) 
     end

     it "returns reason for error in json response" do
       client_response = json_response
       expect(client_response[:errors][:email]).to include "can't be blank"
     end

     it { should respond_with 422 }
   end
 end

 describe "PUT/PATCH #update" do 
   before { @client = FactoryGirl.create :client }
   
   context "successfully" do 
     before do 
       patch :update, {id: @client.id, client: { email: "new@email.com"} }
     end

     it "returns response in json" do 
       client_response = json_response[:client]
       expect(client_response[:email]).to eq "new@email.com"
     end

     it { should respond_with 204 }
   end

   context "unsuccessfully" do 
     before do 
       patch :update, { id: @client.id, client: { email: "bademail.com" } }
     end

     it "returns errors in json response" do 
       client_response = json_response
       expect(client_response).to have_key(:errors)
     end

     it "returns reason for errors in json response" do 
       client_response = json_response
       expect(client_response[:errors][:email]).to include "is invalid"
     end

     it { should respond_with 422 }
   end
 end

 describe "DELETE #destroy" do 
   before do
     @client = FactoryGirl.create :client, admin: false
     delete :destroy, id: @client.id 
   end

   it { should respond_with 204 }
 end
end
