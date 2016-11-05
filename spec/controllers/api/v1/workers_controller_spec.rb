require 'rails_helper'

RSpec.describe Api::V1::WorkersController, type: :controller do
  
  describe "GET #show" do 
    
    context "successful GET request" do 
      before do 
        @worker = FactoryGirl.create :worker
        get :show, id: @worker.id
      end

      it "returns response in json" do 
      	worker_response = json_response[:worker]
      	expect(worker_response[:first_name]).to eq @worker.first_name
      end

      it { should respond_with 200 }
    end

    context "unsuccessful GET request" do
      before do 
        get :show, id: "wrong id"
      end

      it "returns error in json response" do 
      	worker_response = json_response
      	expect(worker_response).to have_key(:errors)
      end

      it "returns reason for error in json response" do 
      	worker_response = json_response
      	expect(worker_response[:errors]).to eq "Record Not Found!"
      end

      it { should respond_with 404 }
    end
  end

  describe "POST #create" do 
    
    context "successful POST request" do
      before do 
      	@worker_attributes = FactoryGirl.attributes_for :worker 
      	post :create, { worker: @worker_attributes }
      end

      it "returns response in json" do 
      	worker_response = json_response[:worker]
      	expect(worker_response[:first_name]).to eq @worker_attributes[:first_name]
      end

      it { should respond_with 201 }
    end

    context "unsuccessful POST request" do 
      before do 
      	@worker_attributes = FactoryGirl.attributes_for :worker
        @worker_attributes[:first_name] = ""
        post :create, { worker: @worker_attributes }
      end	

      it "returns error in json response" do 
        worker_response = json_response
        expect(worker_response).to have_key(:errors)
      end

      it "returns reason for errors in json response" do 
      	worker_response = json_response
      	expect(worker_response[:errors][:first_name]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end



    describe "PUT/PATCH #update" do 
      
      before do 
      	@worker = FactoryGirl.create :worker
      	api_authorization_headers @worker.auth_token
      end

      context "successful PUT/PATCH request" do 
      	before do 
      	  patch :update, { id: @worker.id, worker: { first_name: "Baba", password_confirmation: @worker.password } } 	
      	end

      	it "returns response in json" do 
      	  worker_response = json_response[:worker]
      	  expect(worker_response[:first_name]).to eq "Baba"
      	end

      	it { should respond_with 200 }
      end

      context "unsuccessful PUT/PATCH request" do
      	before do 
      	  patch :update, { id: @worker.id, worker: { age: "thirty-nine" } }	
      	end

      	it "returns error in json response" do 
      	  worker_response = json_response
      	  expect(worker_response).to have_key(:errors)	
      	end

      	it "returns reason for error in json response" do 
      	  worker_response = json_response
      	  expect(worker_response[:errors][:age]).to include "is not a number"	
      	end

      	it { should respond_with 422 }
      end
    end
  end


  describe "DELETE #destroy" do 
    before do 
      @worker = FactoryGirl.create :worker
      api_authorization_headers @worker.auth_token
      delete :destroy, id: @worker.id	
    end	

    it { should respond_with 204 }
  end

end
