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

      it "returns client details in each request in json response" do 
        requests_response = json_response[:requests]
        requests_response.each do |request_response|
          expect(request_response[:client]).to be_present
        end
      end
  	end
  end

  describe "GET #client_request" do 

    context "admin can view requests that belong to a particular request" do     
      before do
        @client = FactoryGirl.create :client
        5.times { FactoryGirl.create :request, client: @client }
        get :client_requests, client_id: @client.id
      end

      # it "returns response in json" do 
      #   requests_response = json_response[:requests]
      # end

      it "returns 5 requests that belong to a client" do 
        expect(@client.requests.count).to eq 5
      end

      it "each request belongs to this client" do
        client_requests_response = json_response[:requests]
        client_requests_response.each do |client_request_response|
          expect(client_request_response[:client][:email]).to eq @client.email
        end
      end

      it { should respond_with 200 }
    end


  end

  describe "GET #show" do
    context "successful GET request" do 
      before do
        @client = FactoryGirl.create :client
        @request_ = FactoryGirl.create :request, client: @client
        get :show, client_id: @client.id, id: @request_.id
      end

      it "returns response in json" do 
        request_response = json_response[:request]
        expect(request_response[:bedrooms]).to eq @request_.bedrooms
      end

      it { should respond_with 200 }

      it "request response contains client details in json response" do 
        request_response = json_response[:request]
        expect(request_response[:client][:email]).to eq @client.email
      end
    end

    context "unsuccessful GET request" do 
      before do
        @client = FactoryGirl.create :client
        get :show, client_id: @client, id: "wrong id"
      end

      it "returns error in json response" do 
        request_response = json_response
        expect(request_response).to have_key(:errors)
      end

      it "returns reason for error in json response" do 
        request_response = json_response
        expect(request_response[:errors]).to eq "Record Not Found!"
      end

      it { should respond_with 404 }
    end
  end

  describe "POST #create" do 

    context "successful POST request" do
      before do
        @client = FactoryGirl.create :client
        @request_attributes = FactoryGirl.attributes_for :request
        post :create, { client_id: @client.id, request: @request_attributes }
      end

      it "returns response in json" do 
        request_response = json_response[:request]
        expect(request_response[:schedule]).to eq @request_attributes[:schedule]
      end

      it "return object in json containing client detail" do 
        request_response = json_response[:request]
        expect(request_response[:client]).to be_present
      end

      it { should respond_with 201 }
    end

    context "unsuccessful POST request" do 
      before do 
        @client = FactoryGirl.create :client
        @request_attributes = FactoryGirl.attributes_for :request
        @request_attributes[:bedrooms] = "two"
        @invalid_attributes = @request_attributes
        post :create, { client_id: @client.id, request: @invalid_attributes }
      end

      it "returns errors in json response" do 
        request_response = json_response
        expect(request_response).to have_key(:errors)
      end

      it "returns reason for errors in json response" do 
        request_response = json_response
        expect(request_response[:errors][:bedrooms]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do 
    
    context "successful update" do 
      before do 
        @client = FactoryGirl.create :client
        @request_ = FactoryGirl.create :request, client: @client
        patch :update, { client_id: @client.id, id: @request_.id, request: { schedule: "every single day" } }
      end

      it "returns response in json" do 
        request_response = json_response[:request]
        expect(request_response[:schedule]).to eq "every single day"
      end

      it "return object in json containing client detail" do 
        request_response = json_response[:request]
        expect(request_response[:client]).to be_present
      end

      it { should respond_with 204 }
    end

    context "unsuccessful update" do
      before do 
        @client = FactoryGirl.create :client
        @request_ = FactoryGirl.create :request, client: @client
        patch :update, { client_id: @client.id, id: @request_.id, request: { bathrooms: "five" } }    
      end

      it "returns error in json resonse" do 
        request_response = json_response
        expect(request_response).to have_key(:errors)
      end

      it "returns reason for error in json response" do 
        request_response = json_response
        expect(request_response[:errors][:bathrooms]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end

  context "DELETE #destroy" do 
    before do
      @client = FactoryGirl.create :client
      @request_ = FactoryGirl.create :request, client: @client
      delete :destroy, client_id: @client, id: @request_.id
    end

    it { should respond_with 204 }
  end
end
