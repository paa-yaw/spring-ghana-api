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

  	context "successfully" do 
      before do 
  	    @worker1 = FactoryGirl.create :worker, status: "UNASSIGNED"
      	@request1 = FactoryGirl.create :request

  	    get :assign_worker, worker_id: @worker1.id, id: @request1.id
  	  end

  	  it "should return json response with request and assigned worker" do 
        request_response = json_response[:request]
        expect(request_response[:worker_ids]).to include @worker1.id
  	  end

  	  it "status of worker should be changed from unassigned to assigned" do
  	    expect{@worker1.engage}.to change{@worker1.status}.from("UNASSIGNED").to("ASSIGNED")
  	  end

  	  it "status of request should be changed from unresolved to resolved" do 
  	    expect{@request1.resolve}.to change{@request1.status}.from("UNRESOLVED").to("RESOLVED")	
  	  end
    end

    context "unsuccessfully" do 
      before do 
      	@worker = FactoryGirl.create :worker
      	@request1 = FactoryGirl.create :request
  	    get :assign_worker, worker_id: "wrong worker id", id: @request1.id
      end

      it "return error in json response" do 
      	request_response = json_response
      	expect(request_response).to have_key(:errors)
      end

      it "returns errors if it can't find worker" do 
      	request_response = json_response
      	expect(request_response[:errors]).to eq "Record Not Found!"
      end

      it { should respond_with 404 }
    end
  end



  describe "#GET #unassign_worker" do
    
    context "successfully" do   
  	  before do
  	    @workers  = FactoryGirl.create(:request_with_workers, workers_count: 3).workers
  	    @worker1  = @workers.first
        @request1 = @workers.first.request
        @worker1.engage

  	    get :unassign_worker, worker_id: @worker1.id, id: @request1.id   
  	  end

  	  it "return response in json that does not include the worker" do 
  	    request_response = json_response[:request]
  	    expect(request_response[:worker_ids]).not_to include @worker1.id  	  	
  	  end

  	  it "status of worker should be changed from unassigned to assigned" do
  	     expect{@worker1.disengage}.to change{@worker1.status}.from("ASSIGNED").to("UNASSIGNED")
  	  end

  	  it { should respond_with 200 }

  	  context "unsuccessfully" do 
  	  	before do 
  	  	  @worker = FactoryGirl.create :worker
  	  	  @request1 = FactoryGirl.create :request
  	  	  get :assign_worker, worker_id: "wrong worker id", id: @request1.id
  	  	end

  	  	it "return error in json response" do 
  	  	  request_response = json_response
  	  	  expect(request_response).to have_key(:errors)
  	  	end

  	  	it "returns errors if it can't find worker" do 
  	  	  request_response = json_response
  	  	  expect(request_response[:errors]).to eq "Record Not Found!"
  	  	end

  	  	it { should respond_with 404 }
  	  end
  	end
  end



  describe "GET #complete_request" do
    
    before do
      @workers = FactoryGirl.create(:request_with_workers, workers_count: 3).workers 
      @worker1 = @workers.first
      @request1 = @worker1.request	
      @request1.status = "RESOLVED"

      get :complete_request, id: @request1.id
    end 

    it "return changed status of request" do 
      request_response = json_response[:request]
      expect(request_response[:status]).to eq "COMPLETED"	
    end

    it "json response should not have workers associated anymore" do 
      request_response = json_response[:request]
      expect(request_response[:worker_ids]).to eq []
    end

    it "previously assigned workers each should have their status changed to UNASSIGNED on completion of a request" do
      @workers.each do |worker|
        expect(worker.status).to eq "UNASSIGNED"
      end	
    end

    it { should respond_with 200 }
  end

end
