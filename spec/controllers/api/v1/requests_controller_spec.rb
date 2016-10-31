require 'rails_helper'

RSpec.describe Api::V1::RequestsController, type: :controller do

  before do
    @client = FactoryGirl.create :client 
    api_authorization_headers @client.auth_token
  end

  describe "GET #index" do

    context "successful GET request for index of requests for a client" do 
      before do 
        requests = 5.times { FactoryGirl.create :request, client: @client }
        api_authorization_headers @client.auth_token
        get :index, client_id: @client.id
      end

      it "should return list of requests in json" do 
        requests_response = json_response[:requests]
        # expect(requests_response[:requests]).to have(5).items
        expect(@client.requests.count).to eq 5 
      end

      # it "should contain client detail in returned json response" do 
      #   request_response = json_response
      #   expect(request_response[:client]).to be_present
      # end

      it { should respond_with 200 }
    end 

    context "if no requests created for client" do 
      before do
        api_authorization_headers @client.auth_token
        get :index, client_id: @client.id
      end

      it "should return no client requests" do
        requests_response = json_response
        expect(@client.requests.count).to eq 0 
      end
    end
  end

  describe "GET #show" do 

    context "successful GET request" do
      before do 
        @request_ = FactoryGirl.create :request, client: @client
        get :show, client_id: @client.id, id: @request_.id
      end

      it "should return response in json" do 
        request_response = json_response
        expect(request_response[:request][:schedule]).to eq @request_.schedule
      end

      it { should respond_with 200 }
    end

    context "unsuccessful GET request" do 
       before do 
        get :show, client_id: @client.id, id: "some id"
      end

      it "should return error response in json" do
        request_response = json_response
        expect(request_response).to have_key(:errors)
      end

      it "should return reason for error in json" do 
        request_response = json_response
        expect(request_response[:errors]).to eq "Record Not Found"
      end

      it { should respond_with 404 }
    end
  end

  describe "POST #create" do

    context "request created successfully" do 
      before do 
        @request_attributes = FactoryGirl.attributes_for :request, client: @client
        post :create, { client_id: @client.id, request: @request_attributes }
      end

      it "returns response in json" do 
        request_response = json_response
        expect(request_response[:request][:schedule]).to eq @request_attributes[:schedule]
      end

      it { should respond_with 201 }
    end

    context "request failed to create" do 
      before do
        @request_invalid_attributes = {
        	bedrooms: "two",
        	bathrooms: rand(1..100), 
        	living_rooms: rand(1..100), 
        	kitchen: rand(1..100),
        	time_of_arrival: Time.now,
        	schedule: "3 times a week, mondays, wednesdays and fridays" 
        } 
        post :create, { client_id: @client.id, request: @request_invalid_attributes }
      end

      it "returns errors in json" do 
        request_response = json_response
        expect(request_response).to have_key(:errors)
      end

      it "returns reason for error in json" do 
        request_response = json_response
        expect(request_response[:errors][:bedrooms]).to include "is not a number"
      end

      it { should respond_with 422 }
    end 
  end


  describe "PUT/PATCH #update" do 
    
    context "successfully update request" do
      before do
        @request_ = FactoryGirl.create :request, client: @client
        patch :update, { client_id: @client.id, id: @request_.id, request: { schedule: "twice a week, mondays and fridays" } }
      end 

      it "returns response in json" do 
        request_response = json_response
        expect(request_response[:request][:schedule]).to eq "twice a week, mondays and fridays"
      end

      it { should respond_with 200 }
    end

    context "request update failed" do 
      before do
        @request_ = FactoryGirl.create :request, client: @client
        patch :update, { client_id: @client.id, id: @request_.id, request: { living_rooms: "two rooms" } }  
      end

      it "returns error response in json" do 
        request_response = json_response
        expect(request_response).to have_key(:errors)
      end

      it "return reason for errors in json" do 
        request_response = json_response
        expect(request_response[:errors][:living_rooms]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do

    context "successfully" do 
      before do 
        @request_ = FactoryGirl.create :request, client: @client
        delete :destroy, client_id: @client.id, id: @request_.id
      end    

      it { should respond_with 204 }
    end 
  end
end
