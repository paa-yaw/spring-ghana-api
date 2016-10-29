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
        expect(client_response[:email]).to eq @client.email
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
        expect(client_response[:email]).to eq @client_attributes[:email]
      end

      it { should respond_with 201 }
    end
  end
end
