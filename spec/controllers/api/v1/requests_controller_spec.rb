require 'rails_helper'

RSpec.describe Api::V1::RequestsController, type: :controller do

  describe "GET #show" do 

    context "successful GET request" do
      before do 
        @request_ = FactoryGirl.create :request
        get :show, id: @request_.id
      end

      it "should return response in json" do 
        request_response = json_response
        expect(request_response[:schedule]).to eq @request_.schedule
      end

      it { should respond_with 200 }
    end

    context "unsuccessful GET request" do 
       before do 
        get :show, id: "some id"
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
        @request_attributes = FactoryGirl.attributes_for :request
        post :create, { request: @request_attributes }
      end

      it "returns response in json" do 
        request_response = json_response
        expect(request_response[:schedule]).to eq @request_attributes[:schedule]
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
        post :create, { request: @request_invalid_attributes }
      end

      it "returns errors in json" do 
        request_response = json_response
        expect(request_response).to have_key(:errors)
      end

      it "returns reason for error in json" do 
        request_response = json_response
        expect(request_response[:errors][:bedrooms]).to eq ["is not a number"]
      end

      it { should respond_with 422 }
    end 
  end


  describe "PUT/PATCH #update" do 
    
    context "successfully update request" do
      before do
        @request_ = FactoryGirl.create :request
        patch :update, { id: @request_.id, request: { schedule: "twice a week, mondays and fridays" } }
      end 

      it "returns response in json" do 
        request_response = json_response
        expect(request_response[:schedule]).to eq "twice a week, mondays and fridays"
      end

      it { should respond_with 200 }
    end

    context "request update failed" do 
      before do
        @request_ = FactoryGirl.create :request
        patch :update, { id: @request_.id, request: { living_rooms: "two rooms" } }  
      end

      it "returns error response in json" do 
        request_response = json_response
        expect(request_response).to have_key(:errors)
      end

      it "return reason for errors in json" do 
        request_response = json_response
        expect(request_response[:errors][:living_rooms]).to eq ["is not a number"]
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do

    context "successfully" do 
      before do 
        @request_ = FactoryGirl.create :request
        delete :destroy, id: @request_.id
      end    

      it { should respond_with 204 }
    end 
  end
end
