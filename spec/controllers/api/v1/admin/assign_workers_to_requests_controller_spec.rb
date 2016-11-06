require 'rails_helper'

RSpec.describe Api::V1::Admin::AssignWorkersToRequestsController, type: :controller do

  
  before do 
  	@admin = FactoryGirl.create :client, admin: true
  	api_authorization_headers @admin.auth_token
  end	

  describe "GET #show" do 
  	context "successfully" do 
      before do 
        @workers  = FactoryGirl.create(:request_with_workers, workers_count: 2).workers
        @request_ = @workers.first.request
        get :show, id: @request_.id
      end

      it "should return a json response " do 
        request_response = json_response[:request]
        expect(request_response[:id]).to eq @request_.id
      end

      it "should return request with associated/assigned workers in json response" do 
        request_response = json_response[:request]
        expect(request_response).to have_key(:worker_ids)
      end

      it { should respond_with 200 }
    end

    context "unsuccessfully" do 
      before do 
        get :show, id: "wrong id"
      end	

      it "should return error in response" do 
      	request_response = json_response
      	expect(request_response).to have_key(:errors)
      end

      it "should return reason for error in json response" do 
      	request_response = json_response
      	expect(request_response[:errors]).to eq "Record Not Found!"
      end

      it { should respond_with 404 }
    end
  end




  describe "GET #assign_worker" do
  	before do 
  	 @workers  = FactoryGirl.create(:request_with_workers, workers_count: 3).workers
  	 @worker1  = @workers.first
     @request1 = @workers.first.request

  	  get :assign_worker, worker_id: @worker1.id, id: @request1.id
  	end

  	it "should return json response with request and assigned worker" do 
      request_response = json_response[:request]
      expect(request_response[:worker_ids]).to include @worker1.id
  	end

  	it "status of worker should be changed from unassigned to assigned" do
  	  expect{@worker1.engage}.to change{@worker1.status}.from("unassigned").to("assigned")
  	end

  	it "status of request should be changed from unresolved to resolved" do 
  	  expect{@request1.resolve}.to change{@request1.status}.from("unresolved").to("resolved")	
  	end
  end



  describe "#UNASSIGN worker" do 
  end



  describe "#ALTER status of request" do 
  end

end
