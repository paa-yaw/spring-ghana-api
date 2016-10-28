require 'rails_helper'

RSpec.describe Api::V1::RequestsController, type: :controller do
  before { request.headers['Accept'] = "application/vnd.spring_ghana.v1" }	

  describe "GET #show" do 

    context "successful GET request" do
      before do 
        @request_ = FactoryGirl.create :request
        get :show, id: @request_.id, format: :json
      end

      it "should return response in json" do 
        request_response = JSON.parse(response.body, symbolize_names: true)
        expect(request_response[:schedule]).to eq @request_.schedule
      end

      it { should respond_with 200 }
    end

    context "unsuccessful GET request" do 
       before do 
        get :show, id: "some id", format: :json
      end

      it "should return error response in json" do
        request_response = JSON.parse(response.body, symbolize_names: true)
        expect(request_response).to have_key(:errors)
      end

      it "should return reason for error in json" do 
        request_response = JSON.parse(response.body, symbolize_names: true)
        expect(request_response[:errors]).to eq "Record Not Found"
      end

      it { should respond_with 404 }
    end
  end
end
