require 'rails_helper'

RSpec.describe Api::V1::ClientsController, type: :controller do

  describe "GET #show" do
    before { @client = FactoryGirl.create :client }

    context "successfully" do 
      before do 
        get :show, id: @client.id
      end

      it "returns response in json" do 
        client_response = json_response
        expect(client_response[:client][:email]).to eq @client.email
      end

      it "returns respons in json containing ids of associated requests" do 
        client_response = json_response[:client]
        expect(client_response[:request_ids]).to eq []
      end

      it { should respond_with 200 }
    end 

    context "unsuccessfully" do 
      before do 
        get :show, id: "some client"	
      end

      it "returns error response in json" do 
      	client_response = json_response
      	expect(client_response).to have_key(:errors)
      end

      it "returns reason for error in json" do
        client_response = json_response
        expect(client_response[:errors]).to eq "client record can't be found"	
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
        client_response = json_response
        expect(client_response[:client][:email]).to eq @client_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context "unsuccessfully" do 
      before do
      	@attributes = FactoryGirl.attributes_for :client
      	@attributes[:email] = ""
      	@invalid_client_attributes = @attributes
      	post :create, {  client: @attributes }
      end

      it "returns response error in json" do 
        client_response = json_response
        expect(client_response).to have_key(:errors)
      end

      it "returns reason for error in json" do 
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
      	api_authorization_headers @client.auth_token
      	patch :update, { id: @client.id, client: { email: "new@email.com" } }
      end

      it "returns response in json" do 
        client_response = json_response
        expect(client_response[:client][:email]).to eq "new@email.com"
      end

      it { should respond_with 204 }
    end

    context "unsuccessfully" do
      before do
      	api_authorization_headers @client.auth_token
        patch :update, { id: @client.id, client: { email: "bademail.com" } }
      end

      it "returns error in json" do 
   		client_response = json_response
   		expect(client_response).to have_key(:errors)
      end

      it "returns reason for error in json" do 
        client_response = json_response
        expect(client_response[:errors][:email]).to include "is invalid"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before { @client = FactoryGirl.create :client }

    before do 
      api_authorization_headers @client.auth_token	
      delete :destroy, id: @client.auth_token
    end 

    it { should respond_with 204 }
  end
end
